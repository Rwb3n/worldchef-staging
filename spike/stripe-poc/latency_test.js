import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 1,
  iterations: 20,
  summaryTrendStats: ['avg', 'p(95)', 'max']
};

export default function () {
  const res = http.post('http://localhost:3334/payments/checkout', null, { timeout: '120s' });
  check(res, {
    'status 200': r => r.status === 200,
    'has url': r => r.json('url') !== undefined,
  });
} 