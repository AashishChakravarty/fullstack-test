import { configureStore } from '@reduxjs/toolkit';
import CompaniesSlice from './company/companiesSlice';
import TransactionsSlice from './transaction/transactionsSlice';

export const store = configureStore({
  reducer: {
    companies: CompaniesSlice,
    transactions: TransactionsSlice,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({ serializableCheck: false }),
});
