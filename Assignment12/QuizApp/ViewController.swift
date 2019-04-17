//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 4/16/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var screenKit: SCNView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    let scene = SCNScene(named: "QuizScene.scn");
    //let scnView: SCNView = SCNView();
    var questionText: SCNNode!;
    var nextBtn: SCNNode!;
    var questions: [Question] = [];
    var currentQuestion: Int = 0;
    var soundAction: SCNAction!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        self.initQuestions();
        self.initScreenView();
        self.initSoundAction();
        self.initTapRecognizer();
        self.loadNewQuestion(0);
    }
    
    func initTapRecognizer(){
        // In viewDidLoad...
        self.tapRecognizer.delegate = self;
        self.tapRecognizer.numberOfTapsRequired = 1;
        self.tapRecognizer.numberOfTouchesRequired = 1;
        self.tapRecognizer.addTarget(self, action: #selector(sceneTapped));
        // Adding gesture recognizer seems to disable camera control scnView.gestureRecognizers = [tapRecognizer]
        
    }
    
    @objc func sceneTapped(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self.screenKit);
        let hitResults = self.screenKit.hitTest(point, options:
            [SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue]);
        for hitResult in hitResults {
            print("tapped node \(hitResult.node.name ?? "Unknown")");
            if hitResult.node == self.nextBtn {
                self.NextBtnSelected();
            }
        }
    }
    
    func loadNewQuestion(_ questionNum: Int)
    {
        let text = self.buildQuestionString();
        self.resetQuestionPosition(self.questionText);
        self.changeTextNodeText(node: self.questionText, text: text);
    }
    
    func NextBtnSelected()
    {
        let action1 = SCNAction.fadeOut(duration: 0.25);
        let action2 = SCNAction.fadeIn(duration: 0.25);
        let blinkAction = SCNAction.sequence([action1,action2]);
        self.nextBtn.runAction(blinkAction);
        self.currentQuestion += 1;
        if self.currentQuestion >= self.questions.count {
            self.currentQuestion = 0;
        }
        self.loadNewQuestion(self.currentQuestion);
    }
    
    func initQuestions()
    {
        for i in 0..<Prompt.count{
            self.questions.append(
                Question(QuizPrompt: Prompt[i],
                Answers: Answers[i],
                CorrectAnswer: CorrectAnswers[i])
            );
        }
    }
    
    func splitTextUp(text: String, count: Int) -> String
    {
        var newStr = "";
        let words = text.components(separatedBy: " ");
        for i in 0..<words.count{
            newStr += (i % count == 0) ? ((i == 0) ? "" : "\n") : " ";
            newStr.append(words[i]);
        }
        return newStr;
    }
    
    func buildQuestionString() -> String
    {
        var completeQuestion: String = "Question \(self.currentQuestion + 1)\n\n";
        let question: Question = questions[self.currentQuestion];
        let prompt: String = self.splitTextUp(text: question.QuizPrompt, count: 5) + "\n\n";
        completeQuestion.append(prompt);
        var answers: String = "";
        let answerNums: [String] = ["a", "b", "c", "d", "e"];
        for i in 0..<question.Answers.count{
            var answer: String = question.Answers[i];
            answer = self.splitTextUp(text: answer, count: 4);
            answer = answerNums[i] + ".) " + answer + "\n";
            answers.append(answer);
        }
        completeQuestion.append(answers);
        return completeQuestion;
    }
    
    func initScreenView()
    {
        //Gets references to existing 3D Text objects in "QuizScene.scn"
        self.screenKit.scene = scene;
        self.screenKit.backgroundColor = UIColor.gray;
        self.addCamera();
        self.addLight();
        self.addAmbientLight();
        self.questionText = self.screenKit.scene?.rootNode.childNode(withName: "QuestionText", recursively: true);
        self.init3DText(node: self.questionText, text: "Question Text");
        self.nextBtn = self.screenKit.scene?.rootNode.childNode(withName: "NextBtn", recursively: true);
        self.init3DText(node: self.nextBtn, text: "Next");
    }
    
    func initSoundAction()
    {
        let audioSource = SCNAudioSource(named: "audio.mp3");
        self.soundAction = SCNAction.playAudio(audioSource!, waitForCompletion: false);
        self.screenKit.scene?.rootNode.runAction(self.soundAction);
    }
    
    func init3DText(node: SCNNode!, text: String)
    {
        // Start/Stop text
        node.geometry = SCNText(string: text, extrusionDepth: 0.5);
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan;
        // Primitive formatting; could do better
        let rootPos = self.screenKit.scene?.rootNode.position;
        node.position.x = rootPos!.x / 2.0 - 1.5;
        node.position.y = -4.5;
        node.position.z = rootPos!.z * 2.0;
        //node.position = SCNVector3(-width/2.0, 0, 0);
        node.scale = SCNVector3(0.1, 0.1, 0.1);
    }
    
    func changeTextNodeText(node: SCNNode!, text: String)
    {
        // Change node text
        let textGeom = node.geometry as! SCNText;
        textGeom.string = text;
    }
    
    func resetQuestionPosition(_ node: SCNNode!)
    {
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.white;
        let nodePhysicsShape = SCNPhysicsShape(geometry: node.geometry!, options: [:]);
        node.physicsBody = SCNPhysicsBody(type: .dynamic,shape: nodePhysicsShape);
        node.physicsBody?.isAffectedByGravity = false;
        node.physicsBody?.friction = 0.0;
        node.physicsBody?.restitution = 1.0;
        node.physicsBody?.damping = 0.0;
        node.pivot = SCNMatrix4MakeTranslation(0, 0, 10);
        let rootPos = self.screenKit.scene?.rootNode.position;
        node.position.x = (rootPos!.x / 2.0) - 7.0;
        node.position.y = rootPos!.y - 20.0;
        node.position.z = rootPos!.z + 15.0;
        let movement = SCNVector3(0.05, 0.05, 0.05);
        let force = SCNVector3(0, 0.3, -0.3);
        node.physicsBody?.applyForce(force, at: movement, asImpulse: true);
    }
    
    func addCamera()
    {
        // create and add a camera to the scene
        let cameraNode: SCNNode! = self.screenKit.scene?.rootNode.childNode(withName: "camera", recursively: true);
        cameraNode.camera = SCNCamera();
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 3, z: 15);
        // allow the user to manipulate the camera
        screenKit.allowsCameraControl = true;
    }
    
    func addLight()
    {
        // create and add point light source to the scene
        let lightNode = SCNNode();
        lightNode.light = SCNLight();
        lightNode.light?.type = .omni;
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10);
        self.scene!.rootNode.addChildNode(lightNode);
    }
    
    func addAmbientLight()
    {
        // create and add ambient light to the scene
        let ambientLightNode = SCNNode();
        ambientLightNode.light = SCNLight();
        ambientLightNode.light?.type = .ambient;
        ambientLightNode.light?.color = UIColor.darkGray;
        self.scene!.rootNode.addChildNode(ambientLightNode);
    }

}
