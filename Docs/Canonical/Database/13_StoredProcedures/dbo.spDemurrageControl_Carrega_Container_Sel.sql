SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spDemurrageControl_Carrega_Container_Sel]
	@Fatura varChar(17)

as
	select 
		Container, Tipo_container, F_Time, dt_devolucao, T_Geral, D_Cobrados, T_Diaria, T_Pagar,
		D_BDP, T_diaria2, T_diaria3, D_1periodo,d_2periodo,d_3periodo 
	from 
		demurrage_ATL_det With(nolock) 
	where 
		processo=left(@Fatura,16)
		and fatura=right(@Fatura,1)
		
GO
