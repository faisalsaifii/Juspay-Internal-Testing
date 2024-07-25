'use client'
import axios from 'axios'

export default function Home() {
	const openPaymentPage = async () => {
		const serverHost = process.env.NEXT_PUBLIC_SERVER_HOST
		const res = await axios.post(`${serverHost}/order`, {
			amount: 1,
		})
		const paymentLink = res.data['payment_links']['web']
		window.open(paymentLink)
	}
	return (
		<main className='flex min-h-screen flex-col items-center justify-center p-24'>
			<button onClick={openPaymentPage}>Pay Now</button>
		</main>
	)
}
