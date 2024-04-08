import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import apiServices from '../../api/axios-service';
import { EndPoints } from '../../api/apiEndpoints';
import {
  apiStatusFailed,
  apiStatusLoading,
  apiStatusSuccess,
} from '../../constants/StringConstants';
import CONSTANTS from '../../utils/constants';

export const companies = createAsyncThunk(
  CONSTANTS.STORE.GET_COMPANY_LIST,
  async (payload, { rejectWithValue }) => {
    try {
      const response = await apiServices.get(EndPoints.companies, {
        params: payload,
      });
      const data = response?.data;
      return data;
    } catch (error) {
      return rejectWithValue(error);
    }
  }
);

const CompaniesSlice = createSlice({
  name: CONSTANTS.STORE.GET_COMPANY_LIST,
  initialState: {
    data: null,
    status: null,
    error: null,
  },
  extraReducers: {
    [companies.pending]: (state, action) => {
      state.status = apiStatusLoading;
    },
    [companies.fulfilled]: (state, action) => {
      state.status = apiStatusSuccess;
      state.data = action.payload;
    },
    [companies.rejected]: (state, action) => {
      state.status = apiStatusFailed;
      state.error = action.payload;
    },
  },
  reducers: {
    resetCompaniesApiError(state, action) {
      state.error = null;
    },
    resetCompaniesApiStatus(state, action) {
      state.status = null;
    },
  },
});

export const { resetCompaniesApiError, resetCompaniesApiStatus } =
  CompaniesSlice.actions;
export default CompaniesSlice.reducer;
