import axios from 'axios';
import {
  geoCodeStatusMessage_OK,
  REQUEST_ISSUE,
  RESPONSE_ISSUE,
  HEADERS_TOKEN,
} from '../constants/StringConstants';
// import {BASE_URL} from '@env';

const serverError = 500;

axios.defaults.baseURL = 'http://localhost:4000/api';
axios.defaults.headers.common['Content-Type'] = 'application/json';
axios.defaults.headers.common.Accept = 'application/json';
axios.defaults.timeout = 30000;

axios.interceptors.response.use(
  (response) => {
    const res = response;
    response.config.meta.responseTime =
      new Date().getTime() - response.config.meta.requestTimestamp;
    return res;
  },
  (error) => {
    if ([401, 403].includes(error.response.status)) {
      localStorage.clear();
      window.location = '/login';
    }

    if (error.response) {
      // internal server error
      let errorObj = {
        errorType: RESPONSE_ISSUE,
        errorBody: error.response.data,
        ErrorStatus: error.response.status,
      };
      return Promise.reject(errorObj);
    } else if (error.request) {
      // request time out network error
      let errorObj = {
        errorType: REQUEST_ISSUE,
        errorBody: error._response,
        ErrorStatus: error.request.status,
      };
      return Promise.reject(errorObj);
    }
  }
);

axios.interceptors.request.use(
  (request) => {
    const token = localStorage.getItem('token');

    request.meta = request.meta || {};
    request.meta.requestTimestamp = new Date().getTime();

    if (token) {
      request.headers.Authorization = `Bearer ${token}`;
    }

    return request;
  },
  (error) => Promise.reject(error)
);

const AxiosService = () => {
  function addHeaders(userConfig) {
    const { params, headers = {}, timeout, ...restConfigs } = userConfig;
    const globalHeaders = {};

    const { ...restParams } = params || {};
    return {
      ...restConfigs,
      headers: {
        ...globalHeaders,
        ...headers,
      },
      params: {
        ...restParams,
      },
      timeout,
    };
  }

  function get(endPoint, userConfig = {}) {
    return axios.get(endPoint, addHeaders(userConfig));
  }

  function post(endPoint, params = {}, userConfig = {}) {
    return axios.post(endPoint, params, addHeaders(userConfig));
  }

  function put(endPoint, params = {}, userConfig = {}) {
    return axios.put(endPoint, params, addHeaders(userConfig));
  }

  function postFormData(endPoint, params = {}, userConfig = {}) {
    const formData = new FormData();
    Object.keys(params).forEach((key) => {
      formData.append(key, params[key]);
    });
    return axios.post(
      endPoint,
      formData,
      addHeaders({ ...userConfig, 'Content-Type': 'multipart/form-data' })
    );
  }

  function putFormData(endPoint, params = {}, userConfig = {}) {
    const formData = new FormData();
    Object.keys(params).forEach((key) => {
      formData.append(key, params[key]);
    });
    return axios.put(
      endPoint,
      formData,
      addHeaders({ ...userConfig, 'Content-Type': 'multipart/form-data' })
    );
  }

  function patchFormData(endPoint, params = {}, userConfig = {}) {
    const formData = new FormData();
    Object.keys(params).forEach((key) => {
      formData.append(key, params[key]);
    });
    return axios.patch(
      endPoint,
      formData,
      addHeaders({ ...userConfig, 'Content-Type': 'multipart/form-data' })
    );
  }

  function remove(endPoint, userConfig = {}) {
    return axios.delete(endPoint, addHeaders(userConfig));
  }

  function patch(endPoint, params = {}, userConfig = {}) {
    return axios.patch(endPoint, params, addHeaders(userConfig));
  }

  return {
    get,
    post,
    put,
    patchFormData,
    postFormData,
    putFormData,
    remove,
    patch,
  };
};

export default AxiosService();
