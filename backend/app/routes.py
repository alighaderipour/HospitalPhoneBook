from flask import Blueprint, request, jsonify
from .models import PhoneNumbers, Jobs, Sections, PhoneTypes,Users
from . import db
api_blueprint = Blueprint('api', __name__)
from sqlalchemy.exc import IntegrityError

# Add Phone Number
@api_blueprint.route('/api/phones/phonenumbers', methods=['POST'])
def add_phonenumber():
    data = request.get_json()
    if not all(key in data for key in ['JobID', 'PhoneNumber']):
        return jsonify({"error": "Missing required fields: JobID, PhoneNumber"}), 400

    try:
        # Check if JobID exists
        job = Jobs.query.get(data['JobID'])
        if not job:
            return jsonify({"error": "Invalid JobID"}), 400

        # Check phone number count for the job
        phone_count = PhoneNumbers.query.filter_by(JobID=data['JobID']).count()
        if phone_count >= 3:
            return jsonify({"error": "Maximum 3 phone numbers allowed per job"}), 400

        # Validate PhoneTypeID if provided
        if 'PhoneTypeID' in data and data['PhoneTypeID']:
            phone_type = PhoneTypes.query.get(data['PhoneTypeID'])
            if not phone_type:
                return jsonify({"error": "Invalid PhoneTypeID"}), 400

        phonenumber = PhoneNumbers(
            JobID=data['JobID'],
            PhoneNumber=data['PhoneNumber'],
            PhoneTypeID=data.get('PhoneTypeID')
        )
        db.session.add(phonenumber)
        db.session.commit()
        return jsonify({
            "PhoneID": phonenumber.PhoneID,
            "JobID": phonenumber.JobID,
            "PhoneNumber": phonenumber.PhoneNumber,
            "PhoneTypeID": phonenumber.PhoneTypeID,
            "message": "Phone number created"
        }), 201
    except IntegrityError as e:
        db.session.rollback()
        return jsonify({"error": "Database constraint violation (e.g., duplicate phone number)"}), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

# Get All Phone Numbers
@api_blueprint.route('/api/phones/phonenumbers', methods=['GET'])
def get_phonenumbers():
    try:
        phonenumbers = PhoneNumbers.query.join(PhoneTypes, isouter=True).all()
        return jsonify([{
            "PhoneID": phone.PhoneID,
            "JobID": phone.JobID,
            "PhoneNumber": phone.PhoneNumber,
            "PhoneTypeName": phone.phone_type.PhoneTypeName if phone.phone_type else None
        } for phone in phonenumbers])
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@api_blueprint.route('/api/phones/<int:phone_id>', methods=['GET'])
def get_phonenumber(phone_id):
    try:
        phone = (
            PhoneNumbers.query
            .join(PhoneTypes, PhoneNumbers.PhoneTypeID == PhoneTypes.PhoneTypeID, isouter=True)
            .filter(PhoneNumbers.PhoneID == phone_id)
            .first()
        )

        if not phone:
            return jsonify({"error": "Phone number not found"}), 404

        return jsonify({
            "PhoneID": phone.PhoneID,
            "JobID": phone.JobID,
            "PhoneNumber": phone.PhoneNumber,
            "PhoneTypeName": phone.phone_type.PhoneTypeName if phone.phone_type else None
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500




# Update Phone Number
@api_blueprint.route('/phones/<int:phone_id>', methods=['PUT'])
def update_phonenumber(phone_id):
    data = request.get_json()
    try:
        phone = PhoneNumbers.query.get(phone_id)
        if not phone:
            return jsonify({"error": "Phone number not found"}), 404

        if 'JobID' in data:
            job = Jobs.query.get(data['JobID'])
            if not job:
                return jsonify({"error": "Invalid JobID"}), 400
            phone.JobID = data['JobID']

        if 'PhoneNumber' in data:
            phone.PhoneNumber = data['PhoneNumber']

        if 'PhoneTypeID' in data:
            if data['PhoneTypeID']:
                phone_type = PhoneTypes.query.get(data['PhoneTypeID'])
                if not phone_type:
                    return jsonify({"error": "Invalid PhoneTypeID"}), 400
            phone.PhoneTypeID = data['PhoneTypeID']

        db.session.commit()
        return jsonify({
            "PhoneID": phone.PhoneID,
            "JobID": phone.JobID,
            "PhoneNumber": phone.PhoneNumber,
            "PhoneTypeID": phone.PhoneTypeID,
            "message": "Phone number updated"
        })
    except IntegrityError as e:
        db.session.rollback()
        return jsonify({"error": "Database constraint violation"}), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

# Delete Phone Number
@api_blueprint.route('/phones/<int:phone_id>', methods=['DELETE'])
def delete_phonenumber(phone_id):
    try:
        phone = PhoneNumbers.query.get(phone_id)
        if not phone:
            return jsonify({"error": "Phone number not found"}), 404
        db.session.delete(phone)
        db.session.commit()
        return jsonify({"message": "Phone number deleted"})
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

# Search Endpoint for Vue.js
@api_blueprint.route('/search', methods=['GET'])
def search():
    query = request.args.get('q', '')
    if not query:
        return jsonify([])

    try:
        users = Users.query.join(Sections).join(Jobs).outerjoin(PhoneNumbers).outerjoin(PhoneTypes).filter(
            db.or_(
                Users.FirstName.ilike(f'%{query}%'),
                Users.LastName.ilike(f'%{query}%'),
                Sections.SectionName.ilike(f'%{query}%'),
                Jobs.JobTitle.ilike(f'%{query}%')
            )
        ).all()

        result = []
        for user in users:
            phone_numbers = [
                {
                    "PhoneNumber": pn.PhoneNumber,
                    "PhoneTypeName": pn.phone_type.PhoneTypeName if pn.phone_type else None
                }
                for pn in user.job.phone_numbers
            ]
            result.append({
                "UserID": user.UserID,
                "FirstName": user.FirstName,
                "LastName": user.LastName,
                "SectionName": user.section.SectionName,
                "JobTitle": user.job.JobTitle,
                "PhoneNumbers": phone_numbers
            })
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500