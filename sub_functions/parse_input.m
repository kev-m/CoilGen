function [input_parser,input] = parse_input(varargin)



%%%%%%input parameter%%%%
%list of valid input variables


input_parser = inputParser; %create parser object
%Add the mesh file that represents the boundary of the target geometry
addRequired(input_parser,'coil_mesh_file');
%Add the spatial function that defines the field
addRequired(input_parser,'field_shape_function',@ischar);
%offset factor for contour levels
addParameter(input_parser,'pot_offset_factor',1/2,@isnumeric);
%file of the coil surface mesh
addParameter(input_parser,'target_mesh_file','none',@ischar);
%shielded_geometry_file; where the field should be supressed
addParameter(input_parser,'secondary_target_mesh_file','none',@ischar);
%shielded_geometry_file; where the field should be supressed
addParameter(input_parser,'secondary_target_weight',1,@isnumeric);
% flag to use only the target mesh vertices as target coordinates
addParameter(input_parser,'use_only_target_mesh_verts',false,@islogical);
%file of an already optimized stream function
addParameter(input_parser,'sf_source_file','none',@ischar);
%Add list of reference files to find common potential range
addParameter(input_parser,'levels',10,@isnumeric);
%Specify one of the three ways the level sets are calculated:
%"primary","combined", or "independent"
addParameter(input_parser,'level_set_method','primary',@ischar);
%fieldtype to evaluate; 'gradient' or 'field'
addParameter(input_parser,'fieldtype_to_evaluate',"field",@isstring);
% flag for cylindrical surface; in case of cylinder, a special parameterization will be used
addParameter(input_parser,'surface_is_cylinder_flag',true,@islogical);
%the width in meter of the opening cut for the interconnection of the loops
addParameter(input_parser,'interconnection_cut_width',0.01,@isnumeric);
%Radius of a spherical target field
addParameter(input_parser,'target_region_radius',0.15,@isnumeric);
%Number of target points per dimension within the target region
addParameter(input_parser,'target_region_resolution',10,@isnumeric);
% the distance in meter for which crossing lines will be seperated along the normal direction of the surface
addParameter(input_parser,'normal_shift_length',0.001,@isnumeric);
%for the cylinder parameterization the ration of outer and inner boundary
addParameter(input_parser,'circular_diameter_factor_cylinder_parameterization',1,@isnumeric);
% the minimal required number of point of a single loop; otherwise loops
% will be removed..
addParameter(input_parser,'min_point_loop_number',20,@isnumeric);
%additional loop removal criteria which relates to the perimeter to surface
%ratio of the loop
addParameter(input_parser,'area_perimeter_deletion_ratio',5,@isnumeric);
%max allowed angle of the track of the contours
addParameter(input_parser,'max_allowed_angle_within_coil_track',120,@isnumeric);
%min allowed angle of the track of the contours; smaller angles will be
%converted to straight lines in order to reduce the number of points
addParameter(input_parser,'min_allowed_angle_within_coil_track',0.0001,@isnumeric);
%minimum relative percentage for which points will be deleted which contribute to segments which is extremly short
addParameter(input_parser,'tiny_segment_length_percentage',0,@isnumeric);
%  segment angle in degree above this parameter will be considered degenerate and therefore deleted
%number of refinement iterations of the mesh together with the stream function
addParameter(input_parser,'iteration_num_stream_func_refinement',0,@isnumeric);
%the direction along the interconnection should be aligned
addParameter(input_parser,'b_0_direction',[0;0;1],@isnumeric);
%In case of pcb layout, specify the track width
addParameter(input_parser,'track_width_factor',0.5,@isnumeric);
%cross_section_width of the conductor (for the inductance calculation) in meter
addParameter(input_parser,'conductor_cross_section_width',0.002,@isnumeric);
%cross_section_width of the conductor (for the inductance calculation) in meter
addParameter(input_parser,'conductor_cross_section_height',0.002,@isnumeric);
%conducter conductiviy
addParameter(input_parser,'specific_conductivity_conductor',0.018*10^(-6),@isnumeric);
%conducter conductiviy
addParameter(input_parser,'conductor_thickness',0.005,@isnumeric); % thickness of the sheet current density of within the stream function representation
%cross_section_width of the conductor (for the inductance calculation) in meter
addParameter(input_parser,'cross_sectional_points',[2 1.5 ;2 -1.5; -2 -1.5; -2 1.5; 2 1.5 ]'/2000,@isnumeric);
%output directory
addParameter(input_parser,'geometry_source_path',strcat(pwd,'\','Geometry_Data'),@ischar);
%Add list of reference files to find common potential range
addParameter(input_parser,'output_directory',strcat(pwd,'\','Results'),@ischar);
%flag to save sweeped .stl
addParameter(input_parser,'save_stl_flag',false,@islogical);
%flag to plot results
addParameter(input_parser,'plot_flag',true,@islogical);
%interconnection_method
addParameter(input_parser,'interconnection_method','regular',@ischar);
%Flag to skip post processing
addParameter(input_parser,'skip_postprocessing',false,@islogical);
%Flag to skip inductance_calculation
addParameter(input_parser,'skip_inductance_calculation',false,@islogical);
%force_cut_selection
addParameter(input_parser,'force_cut_selection',{},@iscell);
%Gaus integration order
addParameter(input_parser,'gauss_order',2,@isnumeric);
% flag to set the roi into the geometric center of the mesh
addParameter(input_parser,'set_roi_into_mesh_center',0,@logical);
% %Tikonov regularization factor for the SF optimization
addParameter(input_parser,'tikonov_reg_factor',1,@isnumeric);


%Parse the input arguments
parse(input_parser,varargin{1}{:});
input=input_parser.Results;

end
