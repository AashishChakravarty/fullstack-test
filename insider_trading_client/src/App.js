import './App.css';
import { BrowserRouter, Route, Switch, Redirect } from 'react-router-dom';
import Company from './pages/Company';
import Transaction from './pages/Transactions';

function App() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/company" component={Company} />
        <Route path="/transactions/:companyId" component={Transaction} />
        <Redirect from="/" to="/company" />
      </Switch>
    </BrowserRouter>
  );
}

export default App;
