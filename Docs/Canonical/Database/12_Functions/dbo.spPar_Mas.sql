SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  	function [dbo].[spPar_Mas]
			(@processo Char(16))

returns
	Float
BEGIN

	Declare @Peso_Mas Float
	Declare @Qty Int
	Declare @Num_Master Varchar(16)
	
	set @Num_Master=(select master from vwcliente where num_proc=@processo)
	if Upper(@Num_Master)='JOB' or @Num_Master=''
		Begin
			return 1
		End
	
	IF LEFT(@PROCESSO,2)='IA' 
		BEGIN
		
		Set @Qty=(
	   		select count(num_proc_hia) from house_imp_aer where num_proc_mia=left(@Num_Master,14)
			)

		if @Qty=1
			Set @peso_mas=1
		
		else
		   BEGIN
			Set @Peso_mas=(
		  			select sum(peso_real_hia) from house_imp_aer where num_proc_mia=left(@Num_Master,14)
					)
			IF @PESO_MAS=0
				BEGIN
					SET @PESO_MAS=1
				END
			Set @peso_mas=(
					select peso_real_hia from house_imp_aer where num_proc_hia=@processo
					)/@peso_mas		
		   END
	END

	IF LEFT(@PROCESSO,2)='EA' 
		BEGIN

				Set @Qty=(
			   		select count(num_proc_hea) from house_exp_aer where num_proc_mea=left(@Num_Master,14)
					)
				if @Qty=1
					Set @Peso_mas=1
				ELSE
				    BEGIN
					Set @Peso_mas=(
			  			select sum(peso_tax) from house_exp_aer where num_proc_mea=left(@Num_Master,14)
						)

					IF @PESO_MAS=0
						BEGIN
							SET @PESO_MAS=1
						END
					Set @peso_mas=(
						select peso_Tax from house_exp_aer where num_proc_hea=@processo
						)/@peso_mas		
				    END

		END

	IF LEFT(@PROCESSO,2)='IM' 
		BEGIN
		
			
				Set @Qty=(
			   		select count(num_proc_hiM) from house_imp_MAr where num_proc_miM=left(@Num_Master,14)
					)
				if @Qty=1
					set @peso_mas=1
				else
				   BEGIN
					Set @Peso_mas=(
			  			select sum(peso_BRUTO_hiM) from house_imp_MAr where num_proc_miM=left(@Num_Master,14)
						)
					IF @PESO_MAS=0
						BEGIN
							SET @PESO_MAS=1
						END

					Set @peso_mas=(
						select peso_BRUTO_hiM from house_imp_MAr where num_proc_hiM=@processo
						)/@peso_mas		
				   END
		END

	IF LEFT(@PROCESSO,2)='EM' 
		BEGIN

				Set @Qty=(
			   		select count(num_proc_hem) from house_exp_mar where num_proc_mem=left(@Num_Master,14)
					)
				if @Qty=1 
					Set @peso_mas=1
				else
				  BEGIN
					Set @Peso_mas=(
			  			select sum(Peso_Bruto_Hem) from house_exp_mar where num_proc_mem=left(@Num_Master,14)
						)
					IF @PESO_MAS=0
						BEGIN
							SET @PESO_MAS=1
						END
					
					Set @peso_mas=(
						select Peso_Bruto_Hem from house_exp_MAR where num_proc_hem=@processo
						)/@peso_mas		
				  END
		END











Return @peso_mas
end



GO
