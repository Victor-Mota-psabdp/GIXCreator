SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spEncerramentoProcesso_Ins] --spEncerramentoProcesso_Ins 'IMSSZ201201002','ATL System'

	@Num_Proc		Varchar(16),
	@Nome_Usuario	Varchar(40)
	
AS

Begin
	Declare @Id int
	Declare @Cd_Pes Varchar(10)
	Declare @Cd_Usuario Varchar(10)
	Declare @Saldo Decimal(10,2)
		
	Declare @Temp Table
		(
			ID Int,
			Num_proc Varchar(16),
			Valor	Decimal(10,2),
			DC		Char(1),
			Nome_Tp_Tx	Varchar(40),
			Tipo	Varchar(30)		
		)
	
	Begin Transaction
	-- Buscas		
		Set @ID = (select max(id) from encerramento_processo)
		if @ID is null
			Begin			
				Set @ID=1			
			End
		Else
			BEgin				
				Set @ID=@ID+1			
			End
		Set @Cd_Pes=(select top 1 cd_cliente from  vwcliente where num_proc=@Num_Proc)
		if @CD_PEs is null 
			begin
				set @Cd_Pes=(select top 1 cd_pes from pessoa where apelido ='BDPT')
			End
		Set @Cd_Usuario=(select top 1 cd_usuario from usuario where nome_usuario=@nome_usuario)
	-- Inserir Cabeçalho
		Insert Encerramento_Processo(ID,Data,Cd_Pes,Valor,cd_usuario,Ativo,Num_Proc) values(@ID,getdate(),@Cd_Pes,0,@Cd_Usuario,1,@Num_Proc)
	
	-- Alimentando
		-- Itens de Conta_Corrente:
			Insert @Temp (Num_Proc,Valor,DC,Nome_Tp_Tx)
			exec spContabilidadeJOB2_Sel @Num_Proc,'N'
			update @Temp set tipo='Cta' where tipo is null
		-- Itens de NF ou Custos
			Insert @Temp (Num_Proc,Valor,DC,Nome_Tp_Tx)
			exec spContabilidadeJOB2_Sel @Num_Proc,'S'
			update @Temp set tipo='NF' where tipo is null

	--Inserindo Encerramento_Processo_Item
		insert Encerramento_Processo_item
		Select @ID,Tipo,num_proc,nome_Tp_tx,dc,valor from @temp
	
	--Atualizado campo saldo
		Set @Saldo=(Select sum(Isnull(valor,0)) from @Temp where Tipo='Cta')
		Set @Saldo = @Saldo - (Select sum(Isnull(valor,0)) from @Temp where Tipo='NF')
		Update Encerramento_Processo set Valor=@Saldo where id=@id
	
	-- Incluindo Cta_Cte
		exec spEncerramentoProcessoCtaCte_Ins @ID,@nome_usuario,@Cd_Pes
	
	
	if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End
	Commit Transaction

End


GO
