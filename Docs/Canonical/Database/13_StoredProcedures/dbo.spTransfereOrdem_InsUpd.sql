SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTransfereOrdem_InsUpd]

	@JOB	varchar(16),
	@SelJOB	varchar(16),
	@cd_user varchar(6)
	
AS

Begin Transaction
	--atualiza o pedido_ship com o novo numero de processo
	IF  exists(select * from pedido_ship where num_proc = @SelJOB)
		
	BEGIN
		UPDATE
			pedido_ship
		SET
			Num_Proc = @JOB,
			cd_usuario = @cd_user,
			dt_ins = getdate()
		WHERE
			num_proc = @SelJOB		
	END
	
	BEGIN
		--insere um log de quem alterou e o dia
		Insert into Log_TransfereOrdem
			values
		(getdate(),@cd_user,@JOB,@SelJOB)			
	End
	
	--verifica se nao existe mais o pedido no job selecionado
	if not exists(select * 
					from llp_imp_mar LLP
						join pedido_ship PS on Ps.num_proc = LLP.num_proc_lim
					where num_proc_lim = @SelJOB)
		--muda o status pra 9 - Cancelado
		begin
			update 
				llp_imp_mar
			set 
				id_status = 9
			where 
				num_proc_lim = @SelJOB
		End

		--Apaga o costs do caso selecionado
	
		IF  exists(select * from custo_cliente where num_proc = @SelJOB)
		
	BEGIN
		delete
			custo_cliente
		WHERE
			num_proc = @SelJOB		
	END	 

Commit Transaction












GO
