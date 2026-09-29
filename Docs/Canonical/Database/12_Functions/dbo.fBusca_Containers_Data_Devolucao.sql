SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	FUNCTION [dbo].[fBusca_Containers_Data_Devolucao]
(
@Processo	Varchar(16)
)
RETURNS Varchar(10)
AS  
BEGIN 
	Declare @Resultado varchar(10)

		Begin
			Set @Resultado= (
				select top 1 Dt_Devol_IM from container_mas_imp_mar MAS
     			join container_hou_imp_mar HOU on HOU.Item_Cont_IM = MAS.Item_Cont_IM and MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
     			where HOU.Num_Proc_HIM = @Processo
				order by Dt_Devol_IM desc
				)

		End

	if @Resultado = ''
		set @Resultado = null

	return @Resultado
	
END




GO
