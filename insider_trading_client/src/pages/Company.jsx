import React, { useEffect, useState } from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { useDispatch, useSelector } from 'react-redux';

import {
  companies,
  resetCompaniesApiError,
  resetCompaniesApiStatus,
} from '../store/company/companiesSlice';
import {
  apiStatusSuccess,
  apiStatusFailed,
} from '../constants/StringConstants';
import TableColumnsCompany from '../Components/Company/TableColumnsCompany';
import ReactTable from '../Components/Common/ReactTable';

function Company() {
  const dispatch = useDispatch();

  const [companiesList, setCompaniesList] = useState([]);
  const [pageCount, setPageCount] = useState(1);
  const [options, setOptions] = useState({
    page: 1,
    limit: 10,
    sortby: '',
    search: '',
    direction: 'asc',
  });

  const companiesState = useSelector((state) => state.companies);

  useEffect(() => {
    dispatch(companies({ ...options }));
  }, [options]);

  useEffect(() => {
    if (companiesState.status === apiStatusSuccess) {
      const data = companiesState.data.data;

      setCompaniesList(data);
      setPageCount(Math.ceil(companiesState.data.count / options.limit));
      dispatch(resetCompaniesApiStatus());
    } else if (companiesState.status === apiStatusFailed) {
      dispatch(resetCompaniesApiError());
      dispatch(resetCompaniesApiStatus());
    }
  }, [companiesState.status]);

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

  const columns = new TableColumnsCompany().getColumns();

  return (
    <>
      <Container>
        <Row>
          <Col as={'h4'} className="my-3">
            Company
          </Col>
        </Row>
        <Row>
          <Col>
            <ReactTable
              columns={columns}
              data={companiesList}
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

export default Company;
