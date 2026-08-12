const { add } = require('./math');

test('adds 2 + 3 to equal 5', () => {
  expect(add(2, 3)).toBe(5);
});

test('adds negative numbers correctly', () => {
  expect(add(-1, -1)).toBe(-2);
});
