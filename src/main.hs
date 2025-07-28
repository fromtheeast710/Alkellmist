import Control.Lens
import Control.Monad
import Parser.Cli
import Parser.Selfies
import Raylib.Core
import Raylib.Core.Models
import Raylib.Core.Text
import Raylib.Types
import Raylib.Util
import Raylib.Util.Colors
import Raylib.Util.Lenses
import Raylib.Util.Math
import Setup
import System.Environment

drawChem :: String -> IO ()
drawChem s = undefined

drawLoop :: String -> Camera3D -> IO Camera3D
drawLoop text cam = do
  rightClick <- isMouseButtonDown MouseButtonRight
  leftClick <- isMouseButtonDown MouseButtonLeft
  wheel <- getMouseWheelMove

  -- TODO: not quite right
  f1 <-
    if rightClick
      then do
        Vector2 dx dy <- (|* (-(1 / cam ^. _camera3D'fovy))) <$> getMouseDelta
        return $ _camera3D'target %~ (|+| Vector3 dx dy 0)
      else return id
  f2 <-
    if wheel /= 0
      then do
        -- TODO: zoom and pan at the same time
        return $ _camera3D'position %~ (|+| Vector3 0 (wheel * 0.5) 0)
      else return id
  f3 <-
    if leftClick
      then do
        Vector2 dx dz <- (|* (-(1 / cam ^. _camera3D'fovy))) <$> getMouseDelta
        return $ _camera3D'position %~ (|+| Vector3 dx 0 dz)
      else return id

  let newCam = f3 $ f2 $ f1 cam

  drawing $ do
    clearBackground black

    mode3D cam $ do
      drawSphere (Vector3 0 0 0) 2.3 red
      drawCylinder (Vector3 0 0 0) 1 1 5 100 gray

    drawText text 10 10 20 white

  return newCam

main :: IO ()
main = do
  (flag, val) <- getArgs >>= parseCli

  setConfigFlags [Msaa4xHint, WindowResizable]

  withWindow screenWidth screenHeight title fps $
    const $
      void $
        whileWindowOpen (drawLoop $ val !! 1) camera
