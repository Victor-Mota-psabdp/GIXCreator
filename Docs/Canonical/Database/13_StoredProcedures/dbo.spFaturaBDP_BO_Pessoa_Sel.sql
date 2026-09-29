SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFaturaBDP_BO_Pessoa_Sel]--'IMATL201406001BR_DA','D'
		@FatCod 	VarChar(19)	,
		@Tipo		char(1) --D-  Draft ou O - Original

AS	

	if @Tipo = 'O'
		BEGIN
			select 
				PS.Apelido Cliente, 
				FatDtVenc, 
				FatObs, 
				
				(case when FT.FatStatus = 0 then 'Cancelled'
					else
				(case when Cd_Tipo  = 'P' and Status_PC ='E'  then
					'Prestação de Contas'
					else
				(case when Cd_Tipo  = 'C' and Status_PC ='E'  then
					'Prestação de Contas'
					else
				(case when D.Processo is not null then
					'Demurrage'				
				else
					'Created'
				end)end)end)end) fatStatus, 
				FatDtEmissao,
				FT.Cd_Pes
			from fatura FT 
				join Pessoa PS on FT.cd_pes= PS.cd_pes 
				left join Fatura_CHB CHB on CHB.Fatura_PC =  FT.FatCod
				left join demurrage_atl D on D.Processo + D.Fatura = FT.FatCod
			where
				FatCod = @FatCod
		END
	ELSE
		BEGIN
			select PS.Apelido Cliente, FatDtVenc, FatObs, 
			--fatStatus, 
			(case when fatstatus = 0 then 'Draft Cancelled'
				else
					'Draft'
				end) fatStatus, 
			FatDtEmissao ,
			FT.Cd_Pes
			from fatura_draft FT
            join Pessoa PS on FT.cd_pes= PS.cd_pes
            where FatCod= @FatCod
		END



GO
