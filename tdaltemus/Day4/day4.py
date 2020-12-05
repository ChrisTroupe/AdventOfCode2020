import json
import re

HCL_PATTERN = "#[a-fA-F0-9]{6}$"
PID_PATTERN = "^[0-9]{9}$"
ECL_OPTIONS = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
REQUIRED_FIELDS = set([
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
])

def readFromFile(fileName):
    file = open(fileName, "r")
    return file.read()

def cleanPassportData(passportData):
    passportData = passportData.strip()
    passportData = passportData.replace("\n", " ")
    while "  " in passportData:
        passportData = passportData.replace("  ", " ")

    passportData = '{ "' + passportData.replace(":", '":"').replace(" ", '", "') + '" }'

    return json.loads(passportData)

def hasAllFields(passport):
    return REQUIRED_FIELDS.issubset(passport.keys())

def solve_day_four_one(passports):
    countValid = 0
    for passport in passports:
        passport = cleanPassportData(passport)
        if hasAllFields(passport):
            countValid += 1

    return countValid

def validByr(byr):
    return int(byr) >= 1920 and int(byr) <= 2002

def validIyr(iyr):
    return int(iyr) >= 2010 and int(iyr) <= 2020

def validEyr(eyr):
    return int(eyr) >= 2020 and int(eyr) <= 2030

def validHgt(hgt):
    hgt = hgt.lower()
    containsIn = "in" in hgt
    containsCm = "cm" in hgt
    if containsIn and not containsCm:
        hgt = int(hgt.replace("in", ""))
        return hgt >= 59 and hgt <= 76
    elif containsCm and not containsIn:
        hgt = int(hgt.replace("cm", ""))
        return hgt >= 150 and hgt <= 193
    else:
        return False

def validHcl(hcl):
    return re.search(HCL_PATTERN, hcl) != None

def validEcl(ecl):
    return ecl.lower() in ECL_OPTIONS

def validPid(pid):
    return re.search(PID_PATTERN, pid)

def validPassport(passport):
    if not hasAllFields(passport): return False
    return validByr(passport["byr"]) and validEcl(passport["ecl"]) and (
        validEyr(passport["eyr"])) and validHcl(passport["hcl"]) and (
        validHgt(passport["hgt"])) and validIyr(passport["iyr"]) and (
        validPid(passport["pid"]))

def solve_day_four_two(passports):
    countValid = 0
    for passport in passports:
        passport = cleanPassportData(passport)
        if validPassport(passport):
            countValid += 1

    return countValid

def main():
    contents = readFromFile("input.txt")
    passports = contents.split("\n\n")
    
    print("There are {} passports".format(solve_day_four_one(passports)))
    print("There are {} passports with valid formatted data".format(solve_day_four_two(passports)))

main()