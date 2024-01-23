import serial
import time, sys, json, io

usleep = lambda x: time.sleep(x/1000000.0)

class UART:
		
	def __init__(self, serial_connection=None, print_tx=False, print_rx=False):
		
		if serial_connection == None:
			raise AttributeError("Serial Connection not defined.")
		
		self.ser = serial_connection

		self.print_tx	= print_tx
		self.print_rx	= print_rx

	def transaction(self, word):
		self.ser.write(word) # send
		recieve = self.ser.read(1)
		usleep(1)

		if self.print_tx:
			print(' -> ',word.hex())
		if self.print_rx:
			print(' <- ', recieve.hex())
		
		return recieve
	
	def send_only(self, word):
		self.ser.write(word)

	def close_connection(self):
		try:
			self.ser.close()
		except Exception as e:
			print("Error Closing Serial Connection: ", e)
		return
	
if __name__ == '__main__':
    ser = serial.Serial('/dev/ttyUSB1',115200, bytesize=8, parity='N', stopbits=1)	
	
    uart_class = UART(serial_connection=ser, print_tx=True, print_rx=True)
    uart_class.transaction(b'\x15')
	

    uart_class.close_connection()

