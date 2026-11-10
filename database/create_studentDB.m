% create_studentDB.m
% Creates studentDB.mat, the student database used by code/DSPjackfruit.m.
%
% Key   : student SRN (exactly as printed on the ID card)
% Value : struct with Name, Course, Year and Phone_num
%
% Phone numbers are replaced with placeholders (xx, yy, zz, aa) for privacy.
% To register a new student, add another line in the same format and run
% this script again.

studentDB = containers.Map();

studentDB('PES1UG23EC203') = struct('Name', 'Nikhil N',    'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'xx');
studentDB('PES1UG23EC200') = struct('Name', 'Nikhil Babu', 'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'yy');
studentDB('PES1UG23EC230') = struct('Name', 'Pruthvi',     'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'zz');
studentDB('PES1UG24EC808') = struct('Name', 'Rakesh',      'Course', 'ECE', 'Year', '2nd', 'Phone_num', 'aa');

save('studentDB.mat', 'studentDB');
fprintf('studentDB.mat created with %d students.\n', studentDB.Count);
