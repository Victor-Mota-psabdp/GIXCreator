SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spDemurrageControl_Faturados_Sel]
	@Num_Proc varChar(16),
	@Container varchar(25),
	@data datetime

as
	select 
		Isnull(sum(d_cobrados),0) Dias, 
		avg(T_Diaria) Diaria,
		avg(T_diaria2) Diaria2, 
		avg(T_diaria3) Diaria3,
		t_geral,f_time,d_bdp,
		t_pagar,d_1periodo, 
		d_2periodo, 
		d_3periodo 
	from 
		demurrage_ATL_det  D With(nolock)  
		Join fatura FAT on left(FAT.FatCod,16)=D.Processo and right(FAT.FatCod,1)=D.Fatura and fatstatus=1
	--join vwFaturasValidas FAT on left(FAT.FatCod,16)=D.Processo and right(FAT.FatCod,1)=D.Fatura
	where 
		processo=@Num_Proc
		and container=@Container
		and convert(datetime,dt_devolucao,105)<=@data 
	group by 
		t_geral,f_time,d_bdp,t_pagar,d_1periodo, d_2periodo, d_3periodo


GO
