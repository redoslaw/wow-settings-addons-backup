--[[
	MrtWoo_AntiSpam: Detects and blocks russian commercial spam and flud
	Copyright (C) 2010 Pavel Dudkovsky (mrtime@era.by)

	This module based on SpamMeNot (filter.lua)
	Copyright (C) 2008 Robert Stiles (robs@codexsoftware.co.uk)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

MrtWoo_AntiSpamFilter = {}

local type = type;
local pairs = pairs;

local strgsub = string.gsub;
local strfind = string.find;
local strlower = string.lower;
local strmatch = string.match;
local strgmatch = string.gmatch;
local strformat = string.format;

MrtWoo_AntiSpamFilter.Words = {};
MrtWoo_AntiSpamFilter.downgradeWeight = 0;

function MrtWoo_AntiSpamFilter:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.weights = self.Words;
	o.cachedRatings = {}
	return o
end

function MrtWoo_AntiSpamFilter:ReloadWords()
	self.weights = self.Words;
end;


function MrtWoo_AntiSpamFilter:RemoveHyperLinks(text)
	text = strgsub(text, "|H.-|h(.-)|h", "%1")
	text = strgsub(text, "|c%w%w%w%w%w%w%w%w(.-)|r", "%1")
	return text
end

-- Tests individual words and returns a summed spam rating.  Words
-- listed in wordsChecked are not checked again
function MrtWoo_AntiSpamFilter:TestWords(weights, wordsChecked, s)
	local w = ""
	local weight = 0
	-- Check individual words
	--for w in strgmatch(s, "%w+") do
	for w in strgmatch(s, "[1234567890abcdefghijklmnopqrstuvwxyzrабвгдеёжзийклмнопрстуфхцчшщъьыэюя]+") do
		if (not wordsChecked[w]) then
			if (weights[w]) then
				if (weights[w] > 0) then
					weight = weight + weights[w];
				else
					self.downgradeWeight = self.downgradeWeight - weights[w];
				end;
			end
			wordsChecked[w] = 1;
			-- MrtWoo:Print(w);
		end
	end
	return weight;
end

function MrtWoo_AntiSpamFilter:NumbersToLetters(s)
	s = strgsub(s, "0" , "o")
	s = strgsub(s, "1" , "l")
	s = strgsub(s, "3" , "e")
	s = strgsub(s, "4" , "a")
	s = strgsub(s, "5" , "s")
	return s
end;

function MrtWoo_AntiSpamFilter:LettersToNumbers(s)
	s = strgsub(s, "o" , "0")
	s = strgsub(s, "l" , "1")
	s = strgsub(s, "e" , "3")
	s = strgsub(s, "a" , "4")
	s = strgsub(s, "s" , "5")
	return s
end;

function MrtWoo_AntiSpamFilter:LatToRus(s)
	s = strgsub(s, "ja", "я");
	s = strgsub(s, "sch", "щ");
	s = strgsub(s, "sh", "щ");

	s = strgsub(s, "e", "е");
	s = strgsub(s, "t", "т");
	s = strgsub(s, "o", "о");
	s = strgsub(s, "p", "р");
	s = strgsub(s, "a", "а");
	s = strgsub(s, "h", "н");
	s = strgsub(s, "k", "к");
	s = strgsub(s, "x", "х");
	s = strgsub(s, "c", "с");
	s = strgsub(s, "b", "в");
	s = strgsub(s, "m", "м");
	s = strgsub(s, "z", "з");
	s = strgsub(s, "i", "и");
	s = strgsub(s, "q", "к");
	s = strgsub(s, "v", "в");
	s = strgsub(s, "w", "в");
	s = strgsub(s, "l", "л");
	s = strgsub(s, "g", "г");
	s = strgsub(s, "d", "д");
	s = strgsub(s, "y", "у");
	s = strgsub(s, "u", "у");
	s = strgsub(s, "s", "с");
	s = strgsub(s, "r", "р");
	s = strgsub(s, "f", "ф");
	s = strgsub(s, "n", "н");

	return s
end;

function MrtWoo_AntiSpamFilter:NumbersToRusLetters(s)
	s = strgsub(s, "0", "о");
	s = strgsub(s, "1", "л");
	s = strgsub(s, "6", "б");

	return s
end;

function MrtWoo_AntiSpamFilter:RusLettersToNumbers(s)
	s = strgsub(s, "о", "0");
	s = strgsub(s, "б", "6");

	return s
end;

function MrtWoo_AntiSpamFilter:RusToLat(s)
	s = strgsub(s, "е", "e");
	s = strgsub(s, "т", "t");
	s = strgsub(s, "о", "o");
	s = strgsub(s, "р", "p");
	s = strgsub(s, "а", "a");
	s = strgsub(s, "н", "h");
	s = strgsub(s, "к", "k");
	s = strgsub(s, "х", "x");
	s = strgsub(s, "с", "c");
	s = strgsub(s, "в", "b");
	s = strgsub(s, "м", "m");
	return s
end;

-- Searches for substring matches for words in the word list
-- Will not check for words listed in wordsFound
function MrtWoo_AntiSpamFilter:TestSubstringWords(weights, wordsFound, s)
	local word = ""
	local value = 0
	local weight = 0

	for word, value in pairs(weights) do
		if not wordsFound[word] then
			if (strmatch(s, word)) then
				weight = weight + value
				wordsFound[word] = 1
			end
		end
	end
	return weight
end

-- Regular spaced word check.
function MrtWoo_AntiSpamFilter:SpacedWordCheck(weights, s)

	local weight = 0
	local wordsChecked = {}

	-- Check individual words
	weight = weight + self:TestWords(weights, wordsChecked, s)

	-- Remove double spacing and replace odd characters used for spaces with real ones
	-- and check again
	local spacestrip = "[^1234567890abcdefghijklmnopqrstuvwxyzr&ЂЈ$!.,%<>=-?абвгдеёжзийклмнопрстуфхцчшщъьыэюя]+"
	s = strgsub(s, spacestrip, " ")

	local _s = s;
	weight = weight + self:TestWords(weights, wordsChecked, s)

	-- Change numbers commonly used as letters to their letter and check again
	s = self:NumbersToLetters(s)
	weight = weight + self:TestWords(weights, wordsChecked, s)

	-- and vice-versa
	s = self:LettersToNumbers(s)
	weight = weight + self:TestWords(weights, wordsChecked, s)

	s = self:RusToLat(s)
	weight = weight + self:TestWords(weights, wordsChecked, s)

	s = _s;

	s = self:LatToRus(s)
	weight = weight + self:TestWords(weights, wordsChecked, s)

	s = self:NumbersToRusLetters(s)
	weight = weight + self:TestWords(weights, wordsChecked, s)

	s = self:RusLettersToNumbers(s)
	weight = weight + self:TestWords(weights, wordsChecked, s)

	--SpamMeNot:DebugMsg("SpaceWordCheck: " .. weight);

	return weight
end

-- Simply search for word matches anywhere in the text
function MrtWoo_AntiSpamFilter:SubstringCheck(weights, s)
	local word = ""
	local value = 0
	local weight = 0

	local wordsFound = {}

	weight = self:TestSubstringWords(weights, wordsFound, s)

	-- Revert numerics
	s = self:NumbersToLetters(s)
	weight = weight + self:TestSubstringWords(weights, wordsFound, s)

	-- and backwards
	s = self:LettersToNumbers(s)
	weight = weight + self:TestSubstringWords(weights, wordsFound, s)

	-- and russian
	s = self:LatToRus(s)
	weight = weight + self:TestSubstringWords(weights, wordsFound, s)

	--SpamMeNot:DebugMsg("SubstringCheck: " .. weight)
	return weight
end

-- The main spam rating formula.  Takes a string and returns a rating.  >= 100 is considered
-- to be spam.
function MrtWoo_AntiSpamFilter:RateMessage(weights, s)
	if type(weights) == "string" then
		s = weights
		weights = self.weights
	end

	--SpamMeNot:DebugMsg("RateMessage: " .. s)

	-- Strip out wow hyperlinks and colors
	s = self:RemoveHyperLinks(s)
	s = strlower(s)

	if self.cachedRatings[s] then
		if self.cachedRatings[s][weights] then
			--SpamMeNot:DebugMsg("Returning cached value: " .. self.cachedRatings[s][weights])
			return self.cachedRatings[s][weights]
		end
	end

	self.downgradeWeight = 0;

	local spacestrip = "[^1234567890abcdefghijklmnopqrstuvwxyzr&ЂЈ$!.,%<>=-?абвгдеёжзийклмнопрстуфхцчшщъьыэюя]+"
	local sCompact = strgsub(s, spacestrip, "")

	local weight1 = self:SpacedWordCheck(weights, s)
	local weight2 = self:SubstringCheck(weights, s)
	local weight3 = self:SubstringCheck(weights, sCompact)

	local weight = weight1
	if weight2 > weight then
		weight = weight2
	end

	if weight3 > weight then
		weight = weight3
	end

	if not self.cachedRatings[s] then
		self.cachedRatings[s] = {}
	end

	local downgradeMax = 50;
	if (MrtWoo) then
		downgradeMax = MrtWoo.db.profile.modules.as_spamrate_needed_for_additional_checks;
	end;

	if (weight > 0) and (self.downgradeWeight > 0) then
		if (self.downgradeWeight > downgradeMax ) then
			self.downgradeWeight = downgradeMax;
		end;
		if (weight - self.downgradeWeight > downgradeMax) then
			weight = weight - self.downgradeWeight;
		end;
	end;

	self.cachedRatings[s][weights] = weight
	return weight
end

function MrtWoo_AntiSpamFilter:ContainsSkillLink(s)
	 --[[
		|Hspell:3127|h[Parry]|h
	]]

	local res = false
	if strfind(s, "|Hspell.-|h(.-)|h") then
		res = true
	end
	return res
end;

function MrtWoo_AntiSpamFilter:RateTradeMessage(s)

	local tradeSkillLinkWeight = 10
	local weight = self:RateMessage(s)

	if self:ContainsSkillLink(s) then
		weight = weight + tradeSkillLinkWeight
	end

	return weight
end
