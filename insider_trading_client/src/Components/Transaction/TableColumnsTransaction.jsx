import React from 'react';

class TableColumnsTransaction {
  constructor() {}

  getColumns = () => {
    return [
      {
        Header: 'Name',
        accessor: 'name',
      },
      {
        Header: 'Job Title',
        accessor: 'job_title',
      },
      {
        Header: 'Date',
        accessor: 'start_date',
      },
      {
        Header: 'Shares',
        accessor: 'shares',
      },
      {
        Header: 'Amount',
        accessor: 'amount',
      },
      {
        Header: 'Market Cap Percentage',
        accessor: 'market_cap_percentage',
      },
    ];
  };
}

export default TableColumnsTransaction;
