SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from produto_cliente where cd_proc_cliente = '00363310'

CREATE Procedure [dbo].[spATL2012_Produto_Cliente_Sel]--'GRUPO DOW','00363310','6','P'

		@Apelido varchar(20),
		@cd_proc_cliente Varchar(30),
		@cd_prod int,		
		@Tipo char(1)
/*
Stored utilizada para alimentação de ComboBox de Produto Cliente
@Tipo = 
	'N' trás o NCM, pelo cd_proc_cliente
	'C' trás o cd_proc_cliente pelo grupo
	'A' trás tudo
	'P' trás tudo pelo cd_prod
*/
AS

	if @Tipo = 'N'
		select NCM_cliente 
		from produto_cliente PC
			join pessoa P on p.cd_pes=pc.cd_cliente
		where apelido = @apelido and cd_Proc_cliente= @cd_proc_cliente

else
	if @Tipo = 'C'
		select cd_proc_cliente 
		from produto_cliente PC
			join pessoa P on p.cd_pes=pc.cd_cliente
		where apelido = @apelido

else
	if @Tipo = 'A'
		select	cd_prod,
				cd_proc_cliente,
				Apelido,
				Produto_Descr,
				NCM_cliente 
		from produto_cliente PC
			join pessoa P on p.cd_pes=pc.cd_cliente
		where apelido = @apelido and cd_Proc_cliente= @cd_proc_cliente
else
	if @Tipo = 'P'
			select	cd_prod,
					cd_proc_cliente,
					Apelido,
					Produto_Descr,
					NCM_cliente 
			from produto_cliente PC
				join pessoa P on p.cd_pes=pc.cd_cliente
			where cd_prod = @cd_prod

GO
