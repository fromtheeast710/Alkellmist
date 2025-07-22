module Setup where

import Raylib.Types

camera :: Camera3D
camera =
  Camera3D
    { camera3D'position = Vector3 0 10 0,
      camera3D'target = Vector3 0 0 0,
      camera3D'up = Vector3 0 0 (-1),
      camera3D'fovy = 45.0,
      camera3D'projection = CameraPerspective
    }

screenWidth :: Int
screenWidth = 1366

screenHeight :: Int
screenHeight = 768

title :: String
title = "Alkellmist" ++ " - " ++ "0.1.0.0"

fps :: Int
fps = 60
