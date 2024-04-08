import React, { useState } from 'react';
import { Form, Row, Col, Table, Pagination } from 'react-bootstrap';
import {
  useTable,
  usePagination,
  useSortBy,
  useGlobalFilter,
  useAsyncDebounce,
} from 'react-table';

const ReactTable = ({
  columns,
  data,
  onFetchData,
  loading,
  pageCount: controlledPageCount,
}) => {
  const [previousSearch, setPreviousSearch] = useState('');
  // Use the state and functions returned from useTable to build your UI
  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    prepareRow,
    page, // Instead of using 'rows', we'll use page,
    // which has only the rows for the active page

    // The rest of these things are super handy, too ;)
    canPreviousPage,
    canNextPage,
    pageOptions,
    pageCount,
    gotoPage,
    nextPage,
    previousPage,
    setPageSize,
    state: { pageIndex, pageSize, sortBy, globalFilter },
    setGlobalFilter,
    setSortBy,
  } = useTable(
    {
      columns,
      data,
      initialState: { pageIndex: 0 },
      manualPagination: true,
      manualGlobalFilter: true,
      manualSortBy: true,
      autoResetPage: false,
      autoResetSortBy: false,
      pageCount: controlledPageCount,
    },
    useGlobalFilter,
    useSortBy,
    usePagination
  );

  React.useEffect(() => {
    onFetchData({ pageIndex, pageSize, sortBy, globalFilter });
  }, [pageIndex, pageSize, sortBy, globalFilter]);

  const onFilteredChange = useAsyncDebounce((value) => {
    setPreviousSearch(value);
    if (value.length > 1 && value.length > previousSearch.length) {
      setGlobalFilter(value || undefined);
    }
    if (value.length < 2 || value.length < previousSearch.length) {
      setGlobalFilter(undefined);
    }
  }, 500);

  // Render the UI for your table
  return (
    <>
      <Row>
        <Col md={4} className="mb-3">
          <Form.Control
            type="text"
            placeholder="Search"
            onChange={(event) => onFilteredChange(event.target.value)}
          />
        </Col>
      </Row>
      <Table striped hover {...getTableProps()}>
        <thead className="thead-dark">
          {headerGroups.map((headerGroup) => (
            <tr {...headerGroup.getHeaderGroupProps()}>
              {headerGroup.headers.map((column) => (
                <th {...column.getHeaderProps(column.getSortByToggleProps())}>
                  {column.render('Header')}
                  <span className="react-table-sort-icon">
                    {column.isSorted ? (
                      column.isSortedDesc ? (
                        <i className="fa fa-sort-down"></i>
                      ) : (
                        <i className="fa fa-sort-up"></i>
                      )
                    ) : (
                      ''
                    )}
                  </span>
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody {...getTableBodyProps()}>
          {page.map((row, i) => {
            prepareRow(row);
            return (
              <tr {...row.getRowProps()}>
                {row.cells.map((cell) => {
                  return (
                    <td {...cell.getCellProps()}>{cell.render('Cell')}</td>
                  );
                })}
              </tr>
            );
          })}
        </tbody>
      </Table>
      <Pagination className="justify-content-end">
        <Pagination.First
          onClick={() => gotoPage(0)}
          disabled={!canPreviousPage}
        />
        <Pagination.Prev
          onClick={() => previousPage()}
          disabled={!canPreviousPage}
        />
        <Pagination.Item active>{pageIndex + 1}</Pagination.Item>
        <Pagination.Next onClick={() => nextPage()} disabled={!canNextPage} />
        <Pagination.Last
          onClick={() => gotoPage(pageCount - 1)}
          disabled={!canNextPage}
        />
        <span className="my-auto mx-2">
          Page{' '}
          <strong>
            {pageIndex + 1} of {pageOptions.length}
          </strong>{' '}
        </span>
        <Form.Control
          as="select"
          className="ml-2 p-1 w-auto react-table-pagination-per-page"
          value={pageSize}
          onChange={(e) => {
            setPageSize(Number(e.target.value));
          }}
        >
          {[10, 20, 30, 40, 50, 100].map((pageSize) => (
            <option key={pageSize} value={pageSize}>
              {pageSize}
            </option>
          ))}
        </Form.Control>
      </Pagination>
    </>
  );
};
export default ReactTable;
