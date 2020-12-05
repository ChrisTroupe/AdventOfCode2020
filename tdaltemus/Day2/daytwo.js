const fs = require("fs");
const path = require("path");

// Reads file contents
const getFileContents = (filePath) => {
  return new Promise((resolve, reject) => {
    fs.readFile(filePath, "utf8", function (err, data) {
      if (err) {
        reject(err);
      }

      resolve(data);
    });
  });
};

const getPasswordAndPolicy = (line) => {
  // Get policy and password
  const [policy, password] = line.split(":");
  // Get amount and letter
  const [amount, letter] = policy.split(" ");
  // Get low and high amounts
  const [first, second] = amount.split("-");

  return [password, letter, first, second];
};

const evaluatePolicy1 = (line) => {
  const [password, letter, low, high] = getPasswordAndPolicy(line);

  // Create regex expression to
  const regex = new RegExp("[^" + letter + "]", "g");
  const letterAmount = password.replace(regex, "").length;

  return letterAmount >= parseInt(low) && letterAmount <= parseInt(high);
};

const evaluatePolicy2 = (line) => {
  const [password, letter, first, second] = getPasswordAndPolicy(line);

  const atFirst = password.trim().charAt(first - 1) === letter;
  const atSecond = password.trim().charAt(second - 1) === letter;
  const atEither = atFirst || atSecond;
  const atBoth = atFirst && atSecond;

  console.log(line);
  console.log(atBoth, atEither, !atBoth && atEither);

  // Check that password has letters in certain positions
  return !atBoth && atEither;
};

// Gets amount correct lines from string[]
const getAmountCorrectFromText = (textArray, evaluationPolicy, index = 0) => {
  // Check if current line exists
  if (!textArray[index]) {
    return 0;
  }

  // Get current line
  const line = textArray[index];
  if (evaluationPolicy(line)) {
    return getAmountCorrectFromText(textArray, evaluationPolicy, index + 1) + 1;
  }

  return getAmountCorrectFromText(textArray, evaluationPolicy, index + 1) + 0;
};

// Solves Day Two Problem 1
const solveDayTwo = async () => {
  // Get file path
  const root = path.dirname(require.main.filename);
  const filePath = root + "/input.txt";
  // Get file contents
  try {
    const fileContents = await getFileContents(filePath);

    // Get each line in different index of array
    const lines = fileContents.split("\r\n");

    // Get the amount correct for policy 1
    console.log(getAmountCorrectFromText(lines, evaluatePolicy1));
    // Get the amount correct for policy 2
    console.log(getAmountCorrectFromText(lines, evaluatePolicy2));
  } catch (e) {
    console.log(e);
  }
};

solveDayTwo();
