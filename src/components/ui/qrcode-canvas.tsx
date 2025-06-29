import { useRef, useEffect, forwardRef } from 'react'

import { renderQRCodeToCanvas } from '@/src/hooks/use-qrcode'

interface QRCodeCanvasProps {
  qrData: Uint8Array | null
  qrSize: number
  originalSize: number
  isLoading?: boolean
  error?: string | null
}

export const QRCodeCanvas = forwardRef<HTMLCanvasElement, QRCodeCanvasProps>(
  ({ qrData, qrSize, originalSize, isLoading, error }, ref) => {
    const canvasRef = useRef<HTMLCanvasElement>(null)

    useEffect(() => {
      const canvas = canvasRef.current
      if (!canvas) return

      if (qrData && qrSize > 0) {
        renderQRCodeToCanvas(canvas, qrData, qrSize, originalSize)
      } else {
        // Clear canvas with white background (matching Chromium)
        const ctx = canvas.getContext('2d')
        if (ctx) {
          const size = 240
          canvas.width = size
          canvas.height = size
          canvas.style.width = '240px'
          canvas.style.height = '240px'

          // Set crisp rendering via CSS classes
          canvas.className = 'block qr-canvas'

          ctx.fillStyle = '#FFFFFF' // White background matching Chromium
          ctx.fillRect(0, 0, size, size)
        }
      }
    }, [qrData, qrSize, originalSize])

    return (
      <>
        <canvas
          ref={(node) => {
            canvasRef.current = node
            if (typeof ref === 'function') {
              ref(node)
            } else if (ref) {
              ref.current = node
            }
          }}
          className='qr-canvas block'
        />

        {/* Error overlay matching Chromium style */}
        {error && !error.includes('too long') && (
          <div className='absolute inset-0 flex items-center justify-center bg-white/90 p-2.5'>
            <p className='text-center text-xs leading-4 text-[#d93025]'>
              {error}
            </p>
          </div>
        )}

        {/* Loading overlay */}
        {isLoading && (
          <div className='absolute inset-0 flex items-center justify-center bg-white/75'>
            <div className='h-8 w-8 animate-spin rounded-full border-b-2 border-[#1a73e8]'></div>
          </div>
        )}
      </>
    )
  }
)

QRCodeCanvas.displayName = 'QRCodeCanvas'
