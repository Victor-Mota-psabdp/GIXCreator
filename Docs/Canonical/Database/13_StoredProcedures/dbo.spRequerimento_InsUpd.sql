SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--30-06-2008
--Week 27
--alteração: @ID_Produto = Cd_Prod da tabela Produto_Cliente - Claudio


CREATE procedure [dbo].[spRequerimento_InsUpd]

	@ID_Req					int,
	@Numero_Requerimento	varchar(15),
	@Consig_Req				varchar(50),
	@UoM_Req				varchar(3),			
	@Quant_Req				float,	
	@Dt_Req					datetime,	
	@Dt_Vencimento_Req		datetime,
	@Cd_Proc_Cliente		varchar(30),
	@ID_ReqN				int OUTPUT

as

Begin Transaction
		Declare @Seq			Varchar(5)
		Declare @Cd_Consig_Req	varchar(10)
		Declare @ID_Produto		int

		Set @CD_Consig_Req = (Select cd_pes from pessoa where apelido = @Consig_Req)
		Set @ID_Produto = (select cd_prod from Produto_Cliente where Cd_Proc_Cliente = @Cd_Proc_Cliente)

	If @ID_Req is null
		Begin
		Set @Seq = (Select isnull(max(ID_Req),0)+1 from requerimento)
		Set @Seq='000'+@Seq
		Set @Seq=right(@Seq,3)
		Set @ID_Req = @Seq
			insert
					Requerimento
						(
							ID_Req,
							Numero_Requerimento,
							Cd_Consig_Req,
							UoM_Req,
							Quant_Req,
							Dt_Req,
							Dt_Vencimento_Req,
							ID_Produto
						)
					Values
						(
							@ID_Req,
							@Numero_Requerimento,
							@Cd_Consig_Req,
							@UoM_Req,
							@Quant_Req,
							@Dt_Req,
							@Dt_Vencimento_Req,
							@ID_Produto
						)
			Set @ID_ReqN = @ID_Req
			End
		Else
			Begin
				Update
					Requerimento
				Set
						Cd_Consig_Req = @Cd_Consig_Req,
						UoM_Req = @UoM_Req,
						Quant_Req = @Quant_Req,
						Dt_Req = @Dt_Req,
						Dt_Vencimento_Req = @Dt_Vencimento_Req,
						ID_Produto = @ID_Produto
				where 
						ID_Req = @ID_Req
			End
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction



GO
