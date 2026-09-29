SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[spDemurrageControl_VerificaFinal_Sel]
	@Num_Proc varChar(16),
	@Container varChar(25)

as
	select 
		DA.Processo+Da.Fatura Fatura, 
		DA.Dt_Emis data,
		DA.Paridade,
		DA.Garantia 
	from 
		demurrage_atl DA With(nolock) 
		join demurrage_ATL_det DAD With(nolock) on DA.processo = DAD.processo and DA.fatura = DAD.fatura 
		--Join fatura FAT With(nolock) on left(FATcod,16)=DA.processo and right(fatcod,1)=DA.fatura and fatstatus=1 
		join vwFaturasValidas FAT on left(FAT.FatCod,16)=DA.Processo and right(FAT.FatCod,1)=DA.Fatura
	where 
		DA.processo =@Num_Proc 
		and tipo = 'F' 
		and container=@Container 
	order by 
		fatura desc

GO
