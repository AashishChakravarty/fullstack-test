import React, { useEffect, useState } from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { useDispatch, useSelector } from 'react-redux';
import { useParams } from 'react-router-dom';
import {
  transactions,
  resetTransactionsApiError,
  resetTransactionsApiStatus,
} from '../store/transaction/transactionsSlice';
import {
  apiStatusSuccess,
  apiStatusFailed,
} from '../constants/StringConstants';
import TableColumnsTransaction from '../Components/Transaction/TableColumnsTransaction';

import ReactTable from '../Components/Common/ReactTable';

function Transaction() {
  const dispatch = useDispatch();
  const { companyId } = useParams();

  const [transactionsList, setTransactionsList] = useState([]);
  const [pageCount, setPageCount] = useState(1);
  const [options, setOptions] = useState({
    page: 1,
    limit: 10,
    sortby: '',
    search: '',
    direction: 'asc',
  });

  const transactionState = useSelector((state) => state.transactions);

  useEffect(() => {
    dispatch(transactions({ id: companyId, payload: options }));
  }, [options]);

  useEffect(() => {
    if (transactionState.status === apiStatusSuccess) {
      const data = transactionState.data.data;
      setTransactionsList(data);
      setPageCount(Math.ceil(transactionState.data.count / options.limit));
      dispatch(resetTransactionsApiStatus());
    } else if (transactionState.status === apiStatusFailed) {
      dispatch(resetTransactionsApiError());
      dispatch(resetTransactionsApiStatus());
    }
  }, [transactionState.status]);

  const onFetchData = ({ pageIndex, pageSize, sortBy, globalFilter }) => {
    var sort = '';
    var direction = '';
    if (sortBy.length) {
      sort = sortBy[0].id;
      direction = sortBy[0].desc ? 'desc' : 'asc';
    }
    setOptions({
      page: pageIndex + 1,
      limit: pageSize,
      sortby: sort,
      search: globalFilter,
      direction,
    });
  };

  const columns = new TableColumnsTransaction().getColumns();

  return (
    <>
      <Container>
        <Row>
          <Col as={'h4'} className="my-3">
            Transactions
          </Col>
        </Row>
        <Row>
          <Col>
            <ReactTable
              columns={columns}
              data={transactionsList}
              onFetchData={onFetchData}
              loading={false}
              pageCount={pageCount}
            />
          </Col>
        </Row>
      </Container>
    </>
  );
}

export default Transaction;
