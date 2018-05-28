import se from './sendEmail';

export const createHandle = ({ sendEmail } = { sendEmail: se }) => () => sendEmail();

export const handle = createHandle();
