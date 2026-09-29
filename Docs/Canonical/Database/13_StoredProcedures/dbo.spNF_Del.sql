SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 25-02-2026 Antonio 
-- Apagar a nota fiscal das tabelas de integração do FazComex
-- atl_int.dbo.JSON_FComex_Nota_Cliente_Line where Id_Processo (deleta por cascade nos itens)   

CREATE PROCEDURE [dbo].[spNF_Del] --'IMFMC201203063BR','004273',''
(
	@Processo		VarChar(16),
	@Nota_Fiscal	VarChar(20),
	@Cliente		Varchar(50),
	@Cd_Usuario		varchar(10),
	@Justifica		varchar(500)
)
AS
Begin Transaction

	Declare	@Cd_Cliente Varchar(10)
	Set @Cd_Cliente =(select Cd_Pes from Pessoa where Apelido = @Cliente)

	UPDATE
		Nota_Cliente
	Set
		Num_proc=Left(num_proc,15)+'D'
	Where
		Num_Proc= @Processo and Nota_Fiscal = @Nota_Fiscal and cd_cliente = @Cd_Cliente
	
	insert 
		Log_Nota_Cliente 
						(
						Dt_NF,
						Num_Proc,
						Nota_Fiscal,
						Cd_Cliente,
						Cd_Usuario,
						Tipo_Oper_NF,
						Justifica
						)
						values
						(
						GETDATE(),
						@Processo,
						@Nota_Fiscal,
						@Cd_Cliente,
						@Cd_Usuario,
						'D',
						@Justifica
						)
		
--25-02-2026 -  Antonio 
    Declare @Id_Processo int
	set @Id_Processo = (select isnull(Id_Processo,0) 
	    from atl_int.dbo.JSON_FComex_JobReferences_Line with(nolock) 
		where num_proc=@Processo) 
	if @id_processo > 0 
		begin 
 		   delete from atl_int.dbo.JSON_FComex_Nota_Cliente_Line  
		   where Id_Processo =@Id_Processo
		   and   Nota_Fiscal =@Nota_Fiscal 
		end 

--DESABILITADO POR ANDERSON EM 04/07/2012'
--	if isnumeric(@nota_fiscal)=1
--		begin
--			UPDATE
--				ATL_BR.dbo.Danfe_Base 
--			Set
--				dtCancel = Getdate(), JustCancel = 'Cancelada via Tela'
--			where
--				Num_Proc= @Processo and nNF = convert(int,@Nota_Fiscal)
--		end

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
	END

Commit Transaction 

GO
