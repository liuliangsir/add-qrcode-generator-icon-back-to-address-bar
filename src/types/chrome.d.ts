declare global {
  interface Window {
    chrome?: {
      tabs: {
        query: (
          queryInfo: { active: boolean; currentWindow: boolean },
          callback: (tabs: Array<{ url?: string }>) => void
        ) => void
      }
      runtime?: {
        getURL: (path: string) => string
      }
    }
  }

  const chrome: {
    tabs: {
      query: (
        queryInfo: { active: boolean; currentWindow: boolean },
        callback: (tabs: Array<{ url?: string }>) => void
      ) => void
    }
    runtime?: {
      getURL: (path: string) => string
    }
  }
}

export {}
