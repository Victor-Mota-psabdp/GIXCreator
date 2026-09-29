SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     function [dbo].[spPar_MasC]
			(@processo_N Char(16),
			 @Tipo Char(1)
			)
returns
	Float

BEGIN

	Declare @Peso_Mas REAL
	Declare @Qty Int
	Declare @Processo varchar(16)

	IF LEFT(@Processo_N,2)='IA' 
			Set @Processo=(
						select top 1 num_proc_mia from house_imp_Aer with(nolock) where num_proc_mia=left(@Processo_N,14)
					)
	IF LEFT(@Processo_N,2)='EA' 
			Set @Processo=(
						select top 1 num_proc_mea from house_exp_Aer with(nolock) where num_proc_mea=left(@Processo_N,14)
					)
	IF LEFT(@Processo_N,2)='IM' 
			Set @Processo=(
						select top 1 num_proc_mim from house_imp_mar with(nolock) where num_proc_mim=left(@Processo_N,14)
					)
	IF LEFT(@Processo_N,2)='EM' 
			Set @Processo=(
						select top 1 num_proc_mem from house_exp_mar with(nolock) where num_proc_mem=left(@Processo_N,14)
					)

	IF @Tipo<>'K'
		BEGIN
			IF LEFT(@Processo,2)='IA' 
				Set @Peso_MAS=(
						select count(num_proc_hia) from house_imp_Aer with(nolock) where num_proc_mia=left(@Processo,14)
					)
			IF left(@Processo,2)='EA'
				Set @Peso_mas=(	
						select count(num_proc_hea) from house_exp_aer with(nolock) where num_proc_mea=left(@processo,14)
					 )
			IF left(@processo,2)='IM'
				Set @Peso_mas=(
						select count(num_proc_him) from house_imp_mar with(nolock) where num_proc_mim=left(@processo,14)
					)
			IF left(@processo,2)='EM'
				Set @Peso_mas=(
						select Isnull(count(num_proc_hem),0) from house_exp_mar with(nolock) where num_proc_mem=left(@processo,14)
					)
			If @Peso_mas=0 
				Begin
					Set @Peso_Mas=1
				End
			set @peso_mas=1/@Peso_mas
		END

	ELSE
	
		BEGIN	

		IF LEFT(@PROCESSO,2)='IA' 
			BEGIN
		
			Set @Qty=(
	   			select count(num_proc_hia) from house_imp_aer with(nolock) where num_proc_mia=left(@Processo,14)
				)

			if @Qty=1
				Set @peso_mas=1
		
			ELSE
		   		BEGIN
					Set @Peso_mas=(
		  				select sum(peso_bruto_hia) from house_imp_aer with(nolock) where num_proc_mia=left(@processo,14)
						)
					if @Peso_Mas=0
						BEGIN
							SET @Peso_Mas=1
						END
				Set @peso_mas=(
						select peso_bruto_hia from house_imp_aer with(nolock) where num_proc_hia=@processo_n
						)/@peso_mas		
		   		END
			END

		IF LEFT(@PROCESSO,2)='EA' 
			BEGIN

			Set @Qty=(
				select count(num_proc_hea) from house_exp_aer with(nolock) where num_proc_mea=left(@Processo,14)
				)
				IF @Qty=1
					Set @Peso_mas=1
				ELSE
			    		BEGIN
						Set @Peso_mas=(
			 				select sum(peso_tax) from house_exp_aer with(nolock) where num_proc_mea=left(@processo,14)
							)
						IF @PESO_MAS=0
							BEGIN
								SET @PESO_MAS=1
							END
						Set @peso_mas=(
							select peso_Tax from house_exp_aer with(nolock) where num_proc_hea=@processo
							)/@peso_mas		
				    	END

			END

		IF LEFT(@PROCESSO,2)='IM' 
			BEGIN
		
			Set @Qty=(
				select count(num_proc_hiM) from house_imp_MAr with(nolock) where num_proc_miM=left(@Processo,14)
				)
				IF @Qty=1
					set @peso_mas=1
				ELSE
				   BEGIN
					Set @Peso_mas=(
			  			select sum(peso_BRUTO_hiM) from house_imp_MAr with(nolock) where num_proc_miM=left(@processo,14)
						)
											IF @PESO_MAS=0
					BEGIN
						SET @PESO_MAS=1
					END
					Set @peso_mas=(
						select peso_BRUTO_hiM from house_imp_MAr with(nolock) where num_proc_hiM=@processo_n
						)/@peso_mas		
				   END
				END

			IF LEFT(@PROCESSO,2)='EM' 
				BEGIN

				Set @Qty=(
					select count(num_proc_hem) from house_exp_mar with(nolock) where num_proc_mem=left(@Processo,14)
					)
				IF @Qty=1 
					Set @peso_mas=1
				ELSE
				  BEGIN
					Set @Peso_mas=(
			  			select sum(Peso_Bruto_Hem) from house_exp_mar with(nolock) where num_proc_mem=left(@processo,14)
						)
						IF @PESO_MAS=0
							BEGIN
								SET @PESO_MAS=1
							END					
					Set @peso_mas=(
						select Peso_Bruto_Hem from house_exp_MAR with(nolock) where num_proc_hem=@processo_n
						)/@peso_mas		
				  END
				END


		END








Return @peso_mas
end












GO
