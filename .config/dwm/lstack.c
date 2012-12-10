void
ltile(Monitor *m) {
	unsigned int i, n, h, mw, my, ty;
	Client *c;

	/* Count number of clients.
	 */
	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	if (n == 0)
		return;

	/* Set master width.
	 */
	if (n > m->nmaster)
		mw = m->nmaster ? m->ww * m->mfact : m->ww;
	else
		mw = 0;

	/* Draw windows.
	 */
	for (i = my = ty = 0, c = nexttiled(m->clients); c;
			c = nexttiled(c->next), i++) {
		/* Position windows.
		 * Apply rules for master window if master, or stack window otherwise.
		 * ATTENTION! mw != mw (see above)
		 */
		if (i < m->nmaster) {
			h = (m->wh - my) / (MIN(n, m->nmaster) - i);
			resize(c, m->wx + mw, m->wy + my,
					m->ww - mw - (2*c->bw), h - (2*c->bw), False);
			my += HEIGHT(c);
		}
		else {
			h = (m->wh - ty) / (n - i);
			resize(c, m->wx, m->wy + ty,
					mw - (2*c->bw), h - (2*c->bw), False);
			ty += HEIGHT(c);
		}
	}
}

