import express from 'express'
import cors from 'cors'
import axios from 'axios'
import dotenv from 'dotenv'
dotenv.config()

const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(cors())

// Juspay Base URLs
// Production: 'https://api.juspay.in'
// Sandbox: 'https://sandbox.juspay.in'
const jpBaseUrl = 'https://api.juspay.in'
const apiKey = process.env.API_KEY
const authorization = `Basic ${Buffer.from(apiKey + ':').toString('base64')}`
const merchantId = process.env.MERCHANT_ID
const clientId = process.env.CLIENT_ID
const PORT = process.env.PORT || 5002
const webhookUsername = 'username'
const webhookPassword = 'password'

// Session API
// Receives request from Frontend to create order with Session API
app.post('/order', async (req, res) => {
	const { amount } = req.body

	const config = {
		method: 'POST',
		url: `${jpBaseUrl}/session`,
		headers: {
			'x-merchantid': merchantId,
			'Content-Type': 'application/json',
			Authorization: authorization,
		},
		data: JSON.stringify({
			order_id: `ord_${Date.now()}`,
			amount: `${amount}`,
			customer_id: 'juspay_test_customer',
			customer_email: 'test@gmail.com',
			customer_phone: '9999999999',
			payment_page_client_id: clientId,
			action: 'paymentPage',
			return_url: 'https://shop.merchant.com',
			description: 'Sample Description',
		}),
	}

	await axios
		.request(config)
		.then((response) => res.status(200).json(response.data))
		.catch((error) =>
			res.status(500).json({
				error: true,
				message: `Issue in making request to Juspay: ${error}`,
			})
		)
})

// Order Status
// Receives request from Frontend to hit Order Status API
app.get('/status', async (req, res) => {
	const { order_id } = req.body
	const config = {
		method: 'GET',
		url: `${jpBaseUrl}/orders/${order_id}`,
		headers: {
			'x-merchantid': merchantId,
			version: '2023-08-20',
			Authorization: authorization,
		},
	}
	await axios
		.request(config)
		.then((jpResponse) => res.status(200).json(jpResponse.data))
		.catch((error) => {
			res.status(400).json(error)
		})
})

// Webhook
app.post('/webhook', (req, res) => {
	if (
		Buffer.from(
			req.headers.authorization.split(' ')[1],
			'base64'
		).toString() === `${webhookUsername}:${webhookPassword}`
	) {
		const { event_name } = req.body
		switch (event_name) {
			case 'ORDER_SUCCEEDED':
				// Verify using Order Status API
				break
			case 'ORDER_FAILED':
				// Verify using Order Status API
				break
			case 'TXN_CREATED':
				// Verify using Order Status API
				break
			case 'TXN_CHARGED':
				// Verify using Order Status API
				break
			case 'TXN_FAILED':
				// Verify using Order Status API
				break
			default:
			// Unhandled event case
		}
		res.status(200).send('Webhook Recieved')
	} else {
		res.status(401).json({
			error: true,
			message: 'Authorization Failed',
		})
	}
})

app.listen(PORT, () => console.log(`Listening on http://localhost:${PORT}`))
