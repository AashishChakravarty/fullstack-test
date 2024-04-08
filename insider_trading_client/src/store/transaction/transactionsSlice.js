import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import apiServices from '../../api/axios-service';
import { EndPoints } from '../../api/apiEndpoints';
import {
  apiStatusFailed,
  apiStatusLoading,
  apiStatusSuccess,
} from '../../constants/StringConstants';
import CONSTANTS from '../../utils/constants';

export const transactions = createAsyncThunk(
  CONSTANTS.STORE.GET_COMPANY_TRANSACTIONS,
  async ({ id, payload }, { rejectWithValue }) => {
    try {
      const response = await apiServices.get(
        EndPoints.transactions + '/' + id,
        {
          params: payload,
        }
      );
      const data = response?.data;
      return data;
    } catch (error) {
      return rejectWithValue(error);
    }
  }
);

const TransactionsSlice = createSlice({
  name: CONSTANTS.STORE.GET_COMPANY_TRANSACTIONS,
  initialState: {
    data: null,
    status: null,
    error: null,
  },
  extraReducers: {
    [transactions.pending]: (state, action) => {
      state.status = apiStatusLoading;
    },
    [transactions.fulfilled]: (state, action) => {
      state.status = apiStatusSuccess;
      state.data = action.payload;
    },
    [transactions.rejected]: (state, action) => {
      state.status = apiStatusFailed;
      state.error = action.payload;
    },
  },
  reducers: {
    resetTransactionsApiError(state, action) {
      state.error = null;
    },
    resetTransactionsApiStatus(state, action) {
      state.status = null;
    },
  },
});

export const { resetTransactionsApiError, resetTransactionsApiStatus } =
  TransactionsSlice.actions;
export default TransactionsSlice.reducer;
