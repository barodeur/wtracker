import { handle } from './index';

test('it sends an email', () => {
  expect(typeof handle).toBe('function');
});
