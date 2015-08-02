using UnityEngine;
using System.Collections;

public class Controller : MonoBehaviour {

	//Public Atributes
	public float speed = 2.0F;
	public float vertical = 2.0F;
	public float control = 1.0F;
	public float rotationSpeed = 1.0F;

	private Rigidbody rb;

	//Drag Control
	private float maxDrag = 3.0F;
	private float maxControl = 20.0F;

	//Rotation Control
	private float smoothRotation = 2.0F;
	private float tiltAngle = 15.0F;
	public float rotation = 0.0F;

	// Use this for initialization
	void Start () {
		rb = GetComponent<Rigidbody> ();
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		float moveHor = Input.GetAxis ("Horizontal");
		float moveVer = Input.GetAxis ("Vertical");
		float tiltY = moveHor * tiltAngle;
		float tiltX = moveVer * tiltAngle;

		if (Input.GetKeyDown(KeyCode.Q)) {
			if(rotation <= 0) {
				rotation = 360.0F;
			} else {
				rotation -= 10.0F;
			}
		} else if (Input.GetKeyDown(KeyCode.E)) {
			if(rotation >= 360) {
				rotation = 0.0F;
			} else {
				rotation += 10.0F;
			}
		}


		Quaternion target = Quaternion.Euler (tiltX, rotation * rotationSpeed, -tiltY);
		Vector3 mov = new Vector3 (moveHor, 0, moveVer);

		transform.rotation = Quaternion.Slerp (transform.rotation, target, Time.deltaTime * smoothRotation);
		rb.drag = calculateDrag (control, maxDrag, maxControl);
		rb.AddForce (mov*speed, ForceMode.Force);
	}

	private float calculateDrag(float actControl, float maxDrag, float maxControl) {
		return (actControl * maxDrag) / maxControl;
	}
}
