import {
  REQUEST_ISSUE,
  REQUEST_ERROR,
  RESPONSE_ISSUE,
  ERROR_401,
  SESSION_EXPIRED_MSG,
  INTERNAL_SERVER_MSG,
  EXCEPTION_ISSUE,
  OOPS_WRONG,
  UNEXPECTED_ERROR,
} from '../constants/StringConstants';

export const getModalErrorText = (errorObj) => {
  let errorText = INTERNAL_SERVER_MSG;
  if (errorObj.errorType === REQUEST_ISSUE) {
    errorText = REQUEST_ERROR;
  } else if (errorObj.errorType === RESPONSE_ISSUE) {
    if (errorObj.ErrorStatus === ERROR_401) errorText = SESSION_EXPIRED_MSG;
    else errorText = errorObj.errorBody.displayMessage;
  } else if (errorObj.errorType === EXCEPTION_ISSUE) {
    errorText = OOPS_WRONG;
  } else {
    errorText = UNEXPECTED_ERROR;
  }
  return errorText;
};
