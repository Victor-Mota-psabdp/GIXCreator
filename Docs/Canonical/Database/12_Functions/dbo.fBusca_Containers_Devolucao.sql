SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================
-- Author:		Claudio Alves
-- Create date: 11-01-2010
-- Description:	Função para trazer qtd de Container ou capacidade utilizada
--	@Tipo:
--		'Cd_Tp_Cont' - Data da devolução do Container por Tipo
-- =========================================================================

CREATE	FUNCTION [dbo].[fBusca_Containers_Devolucao]
(
@Processo	Varchar(16),
@Tipo		Varchar(3)
)
RETURNS datetime
AS  
BEGIN 
	Declare @Resultado datetime

		Begin
			Set @Resultado= (
				select top 1 Dt_Devol_IM from container_mas_imp_mar MAS
     			join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
     			where HOU.Num_Proc_HIM = @Processo and Cd_Tp_Cont in (@Tipo)
--     			group by cd_tp_cont
				order by Dt_Devol_IM desc
				)

		End

	if @Resultado = ''
		set @Resultado = null

	return @Resultado
	
END
/*

select * from container_mas_imp_mar where item_cont_im like '%14567%'
select * from container_hou_imp_mar where num_proc_him like '%IMWAL20090228401%'
select * from tipo_container

select * from house_imp_mar where num_proc_him='IMWAL20090200401'
select dbo.fBusca_Containers_Inf ('IMWAL20090228401','C')
select dbo.fBusca_Containers_Inf ('IMWAL20090228401','20D')
select dbo.fBusca_Containers_Devolucao ('IMWAL20090228401','20D')


*/




GO
