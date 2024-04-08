import React from 'react';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';

class TableColumnsCompany {
  constructor() {}

  getColumns = () => {
    return [
      {
        Header: 'Name',
        accessor: 'name',
      },
      {
        Header: 'Cik',
        accessor: 'cik',
      },
      {
        Header: 'Ticker',
        accessor: 'ticker',
      },
      {
        Header: 'Exchange',
        accessor: 'exchange',
      },
      {
        Header: 'Market Cap',
        accessor: 'market_cap',
      },
      {
        Header: 'Action',
        Cell: ({ row }) => (
          <Link to={`/transactions/${row.original.id}`}>
            <Button>View Transaction</Button>
          </Link>
        ),
      },
    ];
  };
}

export default TableColumnsCompany;
