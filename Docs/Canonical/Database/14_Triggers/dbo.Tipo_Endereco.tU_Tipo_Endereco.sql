SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE trigger [dbo].[tU_Tipo_Endereco] on [dbo].[Tipo_Endereco] for UPDATE as
/* ERwin Builtin Thu Dec 27 21:30:04 2001 */
/* UPDATE trigger on Tipo_Endereco */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCd_Tp_End varchar(3),
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Thu Dec 27 21:30:04 2001 */
  /* Tipo_Endereco R/15 Endereco ON PARENT UPDATE RESTRICT */
  if
    /* update(Cd_Tp_End) */
    update(Cd_Tp_End)
  begin
    if exists (
      select * from deleted,Endereco
      where
        /*  Endereco.Cd_Tp_End = deleted.Cd_Tp_End */
        Endereco.Cd_Tp_End = deleted.Cd_Tp_End
    )
    begin
      select @errno  = 30005,
             @errmsg = 'Cannot UPDATE Tipo_Endereco because Endereco exists.'
      goto error
    end
  end
  /* ERwin Builtin Thu Dec 27 21:30:04 2001 */
  return
error:
	--Alessandra 26/03/2020 - corrigida sintaxe para esse SQL
    --raiserror @errno @errmsg
	raiserror (@errno, @errmsg, 1)
    rollback transaction
end

GO
ALTER TABLE [dbo].[Tipo_Endereco] ENABLE TRIGGER [tU_Tipo_Endereco]
GO
