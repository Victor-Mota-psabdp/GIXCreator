SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spTermoPagamento_InsUpd

	@Cd_Termo	varchar(10),
	@Descricao_Termo varchar(100)


AS

Begin Transaction
	if @Cd_Termo = ''
		begin
			SET @Cd_Termo =(SELECT ISNULL(MAX(cd_termo),1) FROM termo_pagamento)+1
		end
	if exists(select * from termo_pagamento where cd_termo = @Cd_Termo)
		begin
			update
				termo_pagamento
			set 
				descricao_termo = @Descricao_Termo
			where
				cd_termo = @Cd_Termo
		end
	else
		begin
			insert into
				termo_pagamento (cd_Termo,Descricao_Termo)
			values
				(@Cd_Termo, @Descricao_Termo)
		end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction
GO
