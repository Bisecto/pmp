// class OccupationStatus {
//   final String fullName;
//   final String occupationStatus; // Possible values: "Employed", "Self-Employed", "Student", or "Unemployed"
//   final String email;
//   final SelfEmployedProfile? selfEmployedProfile;
//   final EmployedProfile? employedProfile;
//   final StudentProfile? studentProfile;
//
//   OccupationStatus({
//     required this.fullName,
//     required this.occupationStatus,
//     required this.email,
//     this.selfEmployedProfile,
//     this.employedProfile,
//     this.studentProfile,
//   });
//
//   factory OccupationStatus.fromJson(Map<String, dynamic> json) {
//     return OccupationStatus(
//       fullName: json['full_name'],
//       occupationStatus: json['occupation_status'],
//       email: json['email'],
//       selfEmployedProfile: json['self_employed_profile'] != null
//           ? SelfEmployedProfile.fromJson(json['self_employed_profile'])
//           : null,
//       employedProfile: json['employed_profile'] != null
//           ? EmployedProfile.fromJson(json['employed_profile'])
//           : null,
//       studentProfile: json['student_profile'] != null
//           ? StudentProfile.fromJson(json['student_profile'])
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'full_name': fullName,
//       'occupation_status': occupationStatus,
//       'email': email,
//       'self_employed_profile': selfEmployedProfile?.toJson(),
//       'employed_profile': employedProfile?.toJson(),
//       'student_profile': studentProfile?.toJson(),
//     };
//   }
// }
//
// class SelfEmployedProfile {
//   final String natureOfJob;
//   final String jobDescription;
//
//   SelfEmployedProfile({
//     required this.natureOfJob,
//     required this.jobDescription,
//   });
//
//   factory SelfEmployedProfile.fromJson(Map<String, dynamic> json) {
//     return SelfEmployedProfile(
//       natureOfJob: json['nature_of_job'],
//       jobDescription: json['job_description'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'nature_of_job': natureOfJob,
//       'job_description': jobDescription,
//     };
//   }
// }
//
// class EmployedProfile {
//   final String organisation;
//   final String position;
//   final String employerContact;
//   final String organisationLocation;
//
//   EmployedProfile({
//     required this.organisation,
//     required this.position,
//     required this.employerContact,
//     required this.organisationLocation,
//   });
//
//   factory EmployedProfile.fromJson(Map<String, dynamic> json) {
//     return EmployedProfile(
//       organisation: json['organisation'],
//       position: json['position'],
//       employerContact: json['employer_contact'],
//       organisationLocation: json['organisation_location'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'organisation': organisation,
//       'position': position,
//       'employer_contact': employerContact,
//       'organisation_location': organisationLocation,
//     };
//   }
// }
//
// class StudentProfile {
//   final String university;
//   final String studentId;
//   final String department;
//   final String courseOfStudy;
//
//   StudentProfile({
//     required this.university,
//     required this.studentId,
//     required this.department,
//     required this.courseOfStudy,
//   });
//
//   factory StudentProfile.fromJson(Map<String, dynamic> json) {
//     return StudentProfile(
//       university: json['university'],
//       studentId: json['student_id'],
//       department: json['department'],
//       courseOfStudy: json['course_of_study'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'university': university,
//       'student_id': studentId,
//       'department': department,
//       'course_of_study': courseOfStudy,
//     };
//   }
// }
