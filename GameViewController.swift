import UIKit
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    var scnView: SCNView!
    var scene: SCNScene!
    var playerNode: SCNNode!
    var cameraNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupPlayer()
        setupCamera()
        setupStarfield()
    }
    
    // MARK: - Scene Setup
    
    func setupScene() {
        // 1. Initialize the SCNView and SCNScene
        scnView = self.view as? SCNView
        scnView.delegate = self // Set the delegate for the game loop
        scnView.showsStatistics = true // Handy for showing FPS and node count
        scnView.allowsCameraControl = false // We'll control the camera ourselves
        scnView.autoenablesDefaultLighting = true // Basic lighting is essential

        // Create a new scene
        scene = SCNScene()
        scnView.scene = scene
        
        // Make the background black for space
        scnView.backgroundColor = UIColor.black
    }

    // MARK: - Player Setup
    
    func setupPlayer() {
        // 2. Create a basic shape for the player's spaceship
        // We'll use a pyramid to give it a "spaceship" feel
        let playerGeometry = SCNPyramid(width: 1.0, height: 2.0, length: 1.0)
        let playerMaterial = SCNMaterial()
        playerMaterial.diffuse.contents = UIColor.cyan // A cool color for the ship
        playerGeometry.materials = [playerMaterial]
        
        playerNode = SCNNode(geometry: playerGeometry)
        
        // Position the player
        playerNode.position = SCNVector3(x: 0, y: 0, z: -10)
        
        // Rotate the pyramid so the long end points forward (along the negative Z-axis)
        // A 90-degree rotation around the X-axis (π/2)
        playerNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
        
        // Add the player to the scene
        scene.rootNode.addChildNode(playerNode)
        
        // Give the player a name for easy debugging
        playerNode.name = "Player"
    }

    // MARK: - Camera Setup
    
    func setupCamera() {
        // 3. Create the Camera Node
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // Set up the camera position relative to the player
        // This will be a child of the player, so it moves with the player
        let cameraOffset: Float = 10.0 // Distance behind the ship
        let cameraHeight: Float = 3.0 // Height above the ship
        
        cameraNode.position = SCNVector3(x: 0, y: cameraHeight, z: cameraOffset)
        
        // Make the camera look at the player's ship
        // SCNLookAtConstraint makes a node always point at another node
        let lookAtConstraint = SCNLookAtConstraint(target: playerNode)
        lookAtConstraint.isGimbalLockEnabled = true // Prevents weird camera twists
        cameraNode.constraints = [lookAtConstraint]
        
        // Add the camera to the scene (as a child of the root node for now)
        // We will attach it to the player later to make it follow
        scene.rootNode.addChildNode(cameraNode)
        
        // Set this camera as the view's point of view
        scnView.pointOfView = cameraNode
    }

    // MARK: - Starfield Background (Particle System)
    
    func setupStarfield() {
        // 4. Create a simple starfield using a particle system
        let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: nil)!
        let starsNode = SCNNode()
        starsNode.addParticleSystem(stars)
        
        // Position it at the origin and add it to the root node
        starsNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(starsNode)
    }

    // MARK: - SCNSceneRendererDelegate (Game Loop)
    
    /* This is the game loop. It's called before each frame is rendered.
    We'll use this later to update player movement, check for collisions, 
    and move enemies.
    */
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // This function is currently empty, but it's where our core game logic will go!
        // For example, moving the player forward constantly:
        // playerNode.position.z -= 0.1 * Float(time) 
        // We'll tackle movement in the next step.
    }

    // Boilerplate Code for Rotation and Status Bar
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
