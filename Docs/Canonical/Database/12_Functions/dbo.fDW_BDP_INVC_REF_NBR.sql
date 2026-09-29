SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fDW_BDP_INVC_REF_NBR]
(
	@Num_Proc Varchar(16)
)

returns varchar(250)

AS 

BEGIN
	
	Declare @Valor varchar(250)
	SET @Valor = ''

	if LEFT(@NUM_PROC,2)='IM'
		BEGIN
			IF EXISTS(select top 1 Numero_PO_HIM from PO_HIM with(nolock)  where Num_Proc_HIM=@Num_Proc and ID_DC=2)
				BEGIN
					set @valor=(				
							select top 1 Numero_PO_HIM from PO_HIM with(nolock)  where Num_Proc_HIM=@Num_Proc and ID_DC=2
						)
				END
			ELSE
				BEGIN
					set @valor=(				
							select top 1 FAT.FATCOD from fatura FAT with(nolock)
							join House_Imp_Mar HOU with(nolock) on HOU.Cd_Consig_HIM = FAT.Cd_Pes and HOU.Num_Proc_HIM = LEFT(FAT.FatCod,16)
							where HOU.Num_Proc_HiM = @Num_Proc 
						)
				END
		END
	if LEFT(@NUM_PROC,2)='IA'
		BEGIN
			IF EXISTS(select top 1 Numero_PO_HIA from PO_HIA with(nolock)  where Num_Proc_HIA=@Num_Proc and ID_DC=2)
				BEGIN
					set @valor=(				
							select top 1 Numero_PO_HIA from PO_HIA with(nolock)  where Num_Proc_HIA=@Num_Proc and ID_DC=2
						)
				END
			ELSE
				BEGIN
					set @valor=(				
							select top 1 FAT.FATCOD from fatura FAT
							join House_Imp_Aer HOU on HOU.Cd_Consig_HIA = FAT.Cd_Pes and HOU.Num_Proc_HIA = LEFT(FAT.FatCod,16)
							where HOU.Num_Proc_HIA = @Num_Proc 
						)
				END
		END
	if LEFT(@NUM_PROC,2)='IO'
		BEGIN
			IF EXISTS(select top 1 Numero_PO_HIO from PO_HIO with(nolock)  where Num_Proc_HIO=@Num_Proc and ID_DC=2)
				BEGIN
					set @valor=(				
							select top 1 Numero_PO_HIO from PO_HIO with(nolock)  where Num_Proc_HIO=@Num_Proc and ID_DC=2
						)
				END
			ELSE
				BEGIN
					set @valor=(				
							select top 1 FAT.FATCOD from fatura FAT
							join House_Imp_Out HOU on HOU.Cd_Consig_HIO = FAT.Cd_Pes and HOU.Num_Proc_HIO = LEFT(FAT.FatCod,16)
							where HOU.Num_Proc_HIO = @Num_Proc 
						)
				END
		END
			   
	
	if LEFT(@NUM_PROC,2)='EM'
		BEGIN
			IF EXISTS(select top 1 Numero_PO_HEM from PO_HEM with(nolock)  where Num_Proc_HEM=@Num_Proc and ID_DC=2)
				BEGIN
					set @valor=(				
							select top 1 Numero_PO_HEM from PO_HEM with(nolock)  where Num_Proc_HEM=@Num_Proc and ID_DC=2
						)
				END
			ELSE
				BEGIN
					set @valor=(				
							select top 1 FAT.FATCOD from fatura FAT
							join House_Exp_Mar HOU on HOU.Cd_Consig_HEM = FAT.Cd_Pes and HOU.Num_Proc_HEM = LEFT(FAT.FatCod,16)
							where HOU.Num_Proc_HEM = @Num_Proc 
						)
				END
		END

		
	if LEFT(@NUM_PROC,2)='EA'
		BEGIN
			IF EXISTS(select top 1 Numero_PO_HEA from PO_HEA with(nolock)  where Num_Proc_HEA=@Num_Proc and ID_DC=2)
				BEGIN
					set @valor=(				
							select top 1 Numero_PO_HEA from PO_HEA with(nolock)  where Num_Proc_HEA=@Num_Proc and ID_DC=2
						)
				END
			ELSE
				BEGIN
					set @valor=(				
							select top 1 FAT.FATCOD from fatura FAT
							join House_Exp_Aer HOU on HOU.Cd_Consig_HEA = FAT.Cd_Pes and HOU.Num_Proc_HEA = LEFT(FAT.FatCod,16)
							where HOU.Num_Proc_HEA = @Num_Proc 
						)
				END
		END


		
	if LEFT(@NUM_PROC,2)='EO'
		BEGIN
			IF EXISTS(select top 1 Numero_PO_HEO from PO_HEO with(nolock)  where Num_Proc_HEO=@Num_Proc and ID_DC=2)
				BEGIN
					set @valor=(				
							select top 1 Numero_PO_HEO from PO_HEO with(nolock)  where Num_Proc_HEO=@Num_Proc and ID_DC=2
						)
				END
			ELSE
				BEGIN
					set @valor=(				
							select top 1 FAT.FATCOD from fatura FAT
							join House_Exp_Out HOU on HOU.Cd_Consig_HEO = FAT.Cd_Pes and HOU.Num_Proc_HEO = LEFT(FAT.FatCod,16)
							where HOU.Num_Proc_HEO = @Num_Proc 
							)
					END
		END
		
	return @Valor

END


GO
