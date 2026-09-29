SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =========================================================================
-- Author:		Claudio Alves
-- Create date: 17/04/2009
-- Description:	Função para trazer qtd de Container ou capacidade utilizada
--	@Tipo:
--		'C' - Capacidade Utilizada
--		'Cd_Tp_Cont' - Quantidade de Containers por Tipo
--		'Quantidade Total de Container'
-- =========================================================================

CREATE	FUNCTION [dbo].[fBusca_Containers_Inf]
(
@Processo	Varchar(16),
@Tipo		Varchar(3)
)
RETURNS float
AS  
BEGIN 
	Declare @Resultado float

	IF @Tipo = 'C'
		Begin
			Set @Resultado= (
				select 100 *
				(select Vol_Tot_HIM from House_Imp_Mar where Num_Proc_HIM=@Processo)
				/
				(select sum(TC.Capacidade_M3) Capacidade from container_mas_imp_mar MAS
     			join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
				Join Tipo_Container TC on TC.Cd_Tp_Cont=MAS.Cd_Tp_Cont
     			where HOU.Num_Proc_HIM = @Processo and TC.Capacidade_M3 is not null)
				)
		End
	ELSE		
		if @Tipo='T'	
			Begin
				Set @Resultado= (
					select count(isnull(Cd_Tp_Cont,0)) from container_mas_imp_mar MAS
     				join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
     				where HOU.Num_Proc_HIM = @Processo 
     									)

			End
		else
			Begin
				Set @Resultado= (
					select count(isnull(Cd_Tp_Cont,0)) from container_mas_imp_mar MAS
     				join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
     				where HOU.Num_Proc_HIM = @Processo and Cd_Tp_Cont in (@Tipo)
     				group by cd_tp_cont
					)

			End

	return ISNULL(@Resultado,0)
	
END
/*

select * from container_mas_imp_mar where item_cont_im like '%11385%'
select * from container_hou_imp_mar where num_proc_him like '%IMWAL20090104001%'
select * from tipo_container

--insert into tipo_doc_cliente values('61','Carta Borderô',null,'N','S')

select * from house_imp_mar where num_proc_him='IMWAL20090200401'
select dbo.fBusca_Containers_Inf ('IMWAL20090109101','C')
select dbo.fBusca_Containers_Inf ('IMWAL20090104001','20D')
*/




GO
