function [ SI_cell, ermsg ] = make_SI_cell( dm3_struct )
%MAKE_SI_CELL Extracts numerical data from dm3 structure and stores it in
%a cell array
% Each cell contains 2 columns, one with eV array, and one with intensity
% array


ermsg = 'NULL';

if strcmp(dm3_struct.zaxis.units, 'eV')
    numdata = dm3_struct.image_data;  
    sizedata = size(numdata);
    
    %first - we can "Flatten" the data
    flat_SI = [];
    
   for c =1:sizedata(2)
       for r = 1:sizedata(1)
            flat_SI = [flat_SI, reshape(numdata(r,c,:) , [sizedata(3),1] ) ];
       end
   end
   
    evpts = [0 :dm3_struct.zaxis.scale: (sizedata(3) -1)*dm3_struct.zaxis.scale ];
    evpts = (evpts - evpts(dm3_struct.zaxis.origin));
    evpts = reshape(evpts, [length(evpts), 1]);
    index =1;
    for r = 1:sizedata(1)
        for c = 1:sizedata(2)
            %Now re-write the SI in rowmajor form - switch r and c
            SI_cell{r,c} = [ evpts, flat_SI(:,index)];
            index = index +1;           
        end
    end
    
%     ii =1;
%     for r = 1: sizedata(1)
%         for c = 1:sizedata(2)
%             %here interchange r,c in argument of findSpec!!!!!!!
%             [eVarr,intarr, ermsg] = findSpec(dm3_struct,r,c);
%             %disp(ermsg)
%             if not(strcmp(ermsg, 'NULL'))
%                 %Error happened.
%                 disp(ermsg);
%             end
%             
%             eVarr = eVarr'; intarr = intarr'; % convert to column matrices
%             specXY = [eVarr, intarr]; %Spectrum XY arrays concatenated
%             SI_cell{ii} = specXY; ii = ii+1;
%         end
%     end
%     
%     % now we need to reshape this SI_cell by storing it in column major
%     % form
%     ii=1;
%     for i1 = 1: sizedata(1)
%         for i2 = 1:sizedata(2)
%             SI_cell2{i1, i2} = SI_cell{ii};
%             ii = ii+1;
%         end
%     end
    
else
    %not a spectrum image
    ermsg = 'NOT A SPECTRUM IMAGE';
    SI_cell = cell(sizedata(2), sizedata(1) );
end

end

