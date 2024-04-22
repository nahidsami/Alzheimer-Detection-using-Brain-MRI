%Project Title: Alzheimer Detection
%Author: Nahid Sami
%Contact: nahidsami187@gmail.com

function varargout = Alzheimer_detection(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Alzheimer_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Alzheimer_detection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Alzheimer_detection_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);
function varargout = Alzheimer_detection_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function load_Callback(hObject, eventdata, handles)

global img1 img2

[path, nofile] = imgetfile();

if nofile
    msgbox(sprintf('image not found!!!'),'error','warning');
    return
end

img1 = imread(path);
img1 = im2double(img1);
img2 = img1;

axes(handles.axes1);
imshow(img1)

title('\fontsize{20}\color[rgb]{1,0,1} Brain MRI');
function Filter2_Callback(hObject, eventdata, handles)


global img1
axes(handles.axes2)
if size(img1,3)==3
    img1=rgb2gray(img1);
end
K = medfilt2(img1);
axes(handles.axes2);
imshow(K);title('\fontsize{20}\color[rgb]{1,0,1} filtered image');

function detect_edge_Callback(hObject, eventdata, handles)

global img1
axes(handles.axes3);

if size(img1,3)==3
    img1=rgb2gray(img1);
end
K = medfilt2(img1);
C = double(K);

for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %sobel mask for x-direction
        Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        %sobel mask for y-direction
        Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
        
        %the gradient of the image
        %B(i,j)=ab(Gx)+abs(Gy);
        B(i,j)=sqrt(Gx.^2+Gy.^2);
        
    end
end
axes(handles.axes3)
imshow(B);title('\fontsize{20}\color[rgb]{1,0,1} edge detection');
% --- Executes on button press in segmenttion.
function segmenttion_Callback(hObject, eventdata, handles)


global img1
axes(handles.axes4)

if size(img1,3)==3
    img1=rgb2gray(img1);
    img1=medfilt2(img1);
    
end

imdata=reshape(img1,[],1);
imdata=double(imdata);
[IDX nn]=kmeans(imdata,4);
imIDX=reshape(IDX,size(img1));

bw=(imIDX==1);
se=ones(5);
bw=bwareaopen(bw,400);
axes(handles.axes4)
imshow(bw);title('\fontsize{20}\color[rgb]{1,0,1} segmentation');


% --- Executes on button press in detect_Alzheimer.
function detect_Alzheimer_Callback(hObject, eventdata, handles)

global img1
axes(handles.axes5);
K = medfilt2(img1);
bw=im2bw(k, 0.7);
label = bwlabel(bw);

stats=regionprops(label, 'solidity', 'Area');
density=[stats.solidity];
area=[stats.Area];
high_dense_area=density >0.5;
max_area=max(area(high_dense_area));
tumor_label=find(area==max_area);
tumor=ismember(label,tumor_label);

se=strel('square',5);
tumor=imopen(tumor,se)

Bound=bwboundaries(tumor,'noholes');

imshow(K);
hold on

for i=1:length(Bound)
    plot(Bound{i}(:,2),Bound{i}(:,1),'y','linewidth',1.75)
end

title('\fontsize{20}\color[rgb]{1,0,1} Alzheimer detected !!!');

hold off
axes(handles.axes5)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)

msgbox(sprintf('NAHID\Email : nahidsami187@gmail.com'),'Author','Help');


% --------------------------------------------------------------------
function Author_Callback(hObject, eventdata, handles)
handle to Author (see GCBO)

