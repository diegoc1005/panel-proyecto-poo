import { useState, useEffect } from 'react'

export function useDarkMode() {
  const [dark, setDark] = useState(() => {
    return localStorage.getItem('poo-cinetics-dark') === 'true'
  })

  useEffect(() => {
    if (dark) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
    localStorage.setItem('poo-cinetics-dark', dark)
  }, [dark])

  return [dark, setDark]
}
