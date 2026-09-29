SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  Procedure spPgto_Up(
			@proc varchar (16),
			@taxa varchar(3),
			@dc varchar(1),
			@Data_Nova varchar(10),
			@Data_Anterior Varchar(10)
			

		) 

AS

BEGIN
		PRINT 'INICIO'

		if len(@proc)=14
			BEGIN  
				if left(@proc,2)='IA' 
					BEGIN
						UPDATE 
							CTA_CTE_MAS_IMP_AER 
						SET 
							DT_INS_MIA=@DATA_NOVA 
						WHERE 
							CD_TP_TX=@TAXA AND 
							NUM_PROC_MIA=@Proc and 
							dc_mIa=@DC and 
							convert(Datetime,dt_ins_mIa,105)>=convert(datetime,@Data_Anterior,105)
					END
				if left(@proc,2)='EA'
					BEGIN
						print 'MEA'
						UPDATE 
							CTA_CTE_MAS_EXP_AER 
						SET 
							DT_INS_MEA=@DATA_NOVA 
						WHERE CD_TP_TX=@TAXA AND NUM_PROC_MEA=@Proc and dc_mEa=@DC and convert(Datetime,dt_ins_mEa,105)>=convert(datetime,@Data_Anterior,105)
					END

					
				if left(@proc,2)='IM' 
					BEGIN
						UPDATE 
							CTA_CTE_MAS_IMP_mar 
						SET 
							DT_INS_mim=@DATA_NOVA 
						WHERE 
							CD_TP_TX=@TAXA AND 
							NUM_PROC_mim=@Proc and 
							dc_mim=@DC and 
							convert(Datetime,dt_ins_mim,105)>=convert(datetime,@Data_Anterior,105)
					END
				if left(@proc,2)='EM'
					BEGIN
						UPDATE 
							CTA_CTE_MAS_EXP_mar 
						SET 
							DT_INS_mem=@DATA_NOVA 
						WHERE CD_TP_TX=@TAXA AND NUM_PROC_mem=@Proc and dc_mem=@DC and convert(Datetime,dt_ins_mem,105)>=convert(datetime,@Data_Anterior,105)
					END


			END

else

			BEGIN  
				if left(@proc,2)='IA' 
					BEGIN
						UPDATE 
							CTA_CTE_HOU_IMP_AER 
						SET 
							DT_INS_HIA=@DATA_NOVA 
						WHERE 
							CD_TP_TX=@TAXA AND 
							NUM_PROC_HIA=@Proc and 
							dc_HIA=@DC and 
							convert(Datetime,dt_ins_HIA,105)>=convert(datetime,@Data_Anterior,105)
					END
				if left(@proc,2)='EA'
					BEGIN
						UPDATE 
							CTA_CTE_HOU_EXP_AER 
						SET 
							DT_INS_HEA=@DATA_NOVA 
						WHERE CD_TP_TX=@TAXA AND NUM_PROC_HEA=@Proc and dc_HEA=@DC and convert(Datetime,dt_ins_HEA,105)>=convert(datetime,@Data_Anterior,105)
					END

				if left(@proc,2)='IM' 
					BEGIN
						UPDATE 
							CTA_CTE_HOU_IMP_mar 
						SET 
							DT_INS_HIM=@DATA_NOVA 
						WHERE 
							CD_TP_TX=@TAXA AND 
							NUM_PROC_HIM=@Proc and 
							dc_HIM=@DC and 
							convert(Datetime,dt_ins_HIM,105)>=convert(datetime,@Data_Anterior,105)
					END
				if left(@proc,2)='EM'
					BEGIN
						UPDATE 
							CTA_CTE_HOU_EXP_mar 
						SET 
							DT_INS_HEM=@DATA_NOVA 
						WHERE CD_TP_TX=@TAXA AND NUM_PROC_HEM=@Proc and dc_HEM=@DC and convert(Datetime,dt_ins_HEM,105)>=convert(datetime,@Data_Anterior,105)
					END


			END








END








GO
