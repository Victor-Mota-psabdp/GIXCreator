SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Tipo_Status_BO_Sel]--'4','','C'
(
	@ID_Status as int,
	@Status_Descricao as Varchar(30),
	@Tipo as char
)
as
if @Tipo = 'A'
Begin
	if @ID_Status = '' or @ID_Status is null
		Begin
			select ID_Status, Status_Descricao from Tipo_Status_BO
			where Status_Descricao = @Status_Descricao 
		End
	else
		Begin
			select ID_Status, Status_Descricao from Tipo_Status_BO
			where  ID_Status = @ID_Status 
		End
End
If @Tipo = 'B'
	Begin
		if @ID_Status = '' or @ID_Status is null
			Begin
				select ID_Status, Status_Descricao from Tipo_Status_BO
				where Status_Descricao = @Status_Descricao and ativo = 'S'
			End
		else
			Begin
				select ID_Status, Status_Descricao from Tipo_Status_BO
				where  ID_Status = @ID_Status and ativo = 'S'	
			End
	End
If @Tipo = 'C'
	Begin	
		select 
			ID_Status,CtaCte_IUD,Financeiro_IUD,Faturamento_IUD,Job_IUD,Historico_IUD 
		from 
			Tipo_Status_BO
		where 
			ID_Status = @ID_Status and ativo = 'S'			
	End
	
If @Tipo = 'D'
	Begin
		Select '0 - Todos'	[Status]
		union all 
		select 
			convert(varchar(1),ID_Status) + ' - ' + Status_Descricao  [Status]
		from 
			Tipo_Status_BO
		where 
			ativo = 'S'			
	End


GO
